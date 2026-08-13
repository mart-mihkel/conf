import {
  chmod,
  copyFile,
  lstat,
  mkdir,
  mkdtemp,
  readlink,
  rm,
  symlink,
} from "node:fs/promises";
import { dirname, join, relative, resolve, sep } from "node:path";
import type {
  ExtensionAPI,
  ExtensionCommandContext,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";

const STATE_TYPE = "pi-undo-redo";
const SNAPSHOT_TIMEOUT = 30_000;

type SnapshotFile = {
  exists: boolean;
  source?: string;
  mode?: number;
  symlink?: string;
};

type WorkspaceSnapshot = {
  root: string;
  tracked: string[];
  files: Record<string, SnapshotFile>;
};

type UndoRecord = {
  userEntryId: string;
  parentId: string | null;
  endLeafId: string | null;
  prompt: string;
  before: WorkspaceSnapshot;
  after: WorkspaceSnapshot;
};

type PersistedState = {
  kind: "record";
  record: UndoRecord;
};

type SessionManagerWithReset = ExtensionCommandContext["sessionManager"] & {
  resetLeaf: () => void;
};

export default function (pi: ExtensionAPI) {
  let history: UndoRecord[] = [];
  let redoStack: UndoRecord[] = [];
  let pending:
    | {
        userEntryId: string;
        parentId: string | null;
        prompt: string;
        before: WorkspaceSnapshot;
      }
    | undefined;

  pi.on("session_start", (_event, ctx) => {
    history = [];
    redoStack = [];
    pending = undefined;
    for (const entry of ctx.sessionManager.getEntries()) {
      if (entry.type !== "custom" || entry.customType !== STATE_TYPE) continue;
      const data = entry.data as Partial<PersistedState> | undefined;
      if (data?.kind === "record" && data.record) history.push(data.record);
    }
  });

  pi.on("agent_start", async (_event, ctx) => {
    redoStack = [];
    const userEntry = findLastUserEntry(ctx);
    if (!userEntry) return;

    try {
      const before = await captureSnapshot(pi, ctx);
      if (!before) return;
      pending = {
        userEntryId: userEntry.id,
        parentId: userEntry.parentId,
        prompt: userEntry.prompt,
        before,
      };
    } catch (error) {
      pending = undefined;
      notify(ctx, `Undo snapshot failed: ${errorMessage(error)}`, "warning");
    }
  });

  pi.on("agent_end", async (_event, ctx) => {
    if (!pending) return;
    const current = pending;
    pending = undefined;

    try {
      const after = await captureSnapshot(pi, ctx);
      if (!after) return;
      const record: UndoRecord = {
        ...current,
        endLeafId: ctx.sessionManager.getLeafId(),
        after,
      };

      history.push(record);
      pi.appendEntry(STATE_TYPE, {
        kind: "record",
        record,
      } satisfies PersistedState);
    } catch (error) {
      notify(ctx, `Undo snapshot failed: ${errorMessage(error)}`, "warning");
    }
  });

  pi.registerCommand("undo", {
    description: "Undo the last user message and restore its file changes",
    handler: async (_args, ctx) => {
      await stopAgent(ctx);
      const branch = new Set(
        ctx.sessionManager.getBranch().map((entry) => entry.id),
      );

      const record = findLastUndoable(history, redoStack, branch);
      if (!record) {
        ctx.ui.notify("Nothing to undo", "warning");
        return;
      }

      await restoreSnapshot(pi, ctx.cwd, record.before, record.after);
      await moveTo(ctx, record.parentId);
      redoStack.push(record);
      ctx.ui.setEditorText(record.prompt);
      ctx.ui.notify("Undid the last message and file changes", "info");
    },
  });

  pi.registerCommand("redo", {
    description: "Redo the last undone message and restore its file changes",
    handler: async (_args, ctx) => {
      await stopAgent(ctx);
      const record = redoStack.at(-1);
      if (!record) {
        ctx.ui.notify("Nothing to redo", "warning");
        return;
      }

      await restoreSnapshot(pi, ctx.cwd, record.after, record.before);
      await moveTo(ctx, record.endLeafId);
      redoStack.pop();
      ctx.ui.setEditorText("");
      ctx.ui.notify("Redid the message and file changes", "info");
    },
  });
}

async function stopAgent(ctx: ExtensionCommandContext): Promise<void> {
  if (!ctx.isIdle()) ctx.abort();
  await ctx.waitForIdle();
}

function findLastUserEntry(
  ctx: ExtensionContext,
): { id: string; parentId: string | null; prompt: string } | undefined {
  const branch = ctx.sessionManager.getBranch();
  for (let index = branch.length - 1; index >= 0; index--) {
    const entry = branch[index];
    if (
      entry?.type !== "message" ||
      !("role" in entry.message) ||
      entry.message.role !== "user"
    ) {
      continue;
    }

    if (!("content" in entry.message)) continue;
    return {
      id: entry.id,
      parentId: entry.parentId,
      prompt: userPrompt(entry.message.content),
    };
  }

  return undefined;
}

function findLastUndoable(
  records: UndoRecord[],
  redoStack: UndoRecord[],
  branch: Set<string>,
): UndoRecord | undefined {
  const redoIds = new Set(redoStack.map((record) => record.userEntryId));
  for (let index = records.length - 1; index >= 0; index--) {
    const record = records[index];
    if (
      record &&
      branch.has(record.userEntryId) &&
      !redoIds.has(record.userEntryId)
    ) {
      return record;
    }
  }

  return undefined;
}

async function captureSnapshot(
  pi: ExtensionAPI,
  ctx: ExtensionContext,
): Promise<WorkspaceSnapshot | undefined> {
  const repository = await pi.exec(
    "git",
    ["rev-parse", "--is-inside-work-tree"],
    {
      cwd: ctx.cwd,
      timeout: SNAPSHOT_TIMEOUT,
      signal: ctx.signal,
    },
  );

  if (repository.code !== 0 || repository.stdout.trim() !== "true") {
    notify(ctx, "Undo requires a Git worktree", "warning");
    return undefined;
  }

  const [trackedResult, changedResult, untrackedResult] = await Promise.all([
    pi.exec("git", ["ls-files", "-z"], {
      cwd: ctx.cwd,
      timeout: SNAPSHOT_TIMEOUT,
      signal: ctx.signal,
    }),
    pi.exec("git", ["diff", "--name-only", "-z", "HEAD"], {
      cwd: ctx.cwd,
      timeout: SNAPSHOT_TIMEOUT,
      signal: ctx.signal,
    }),
    pi.exec("git", ["ls-files", "--others", "--exclude-standard", "-z"], {
      cwd: ctx.cwd,
      timeout: SNAPSHOT_TIMEOUT,
      signal: ctx.signal,
    }),
  ]);

  if (
    trackedResult.code !== 0 ||
    changedResult.code !== 0 ||
    untrackedResult.code !== 0
  ) {
    throw new Error("Unable to inspect Git worktree");
  }

  const tracked = splitNul(trackedResult.stdout);
  const changed = new Set([
    ...splitNul(changedResult.stdout),
    ...splitNul(untrackedResult.stdout),
  ]);

  const root = await snapshotDirectory(ctx);
  const files: Record<string, SnapshotFile> = {};

  for (const path of changed) {
    const absolute = safePath(ctx.cwd, path);
    const state = await fileSnapshot(absolute, root, path);
    files[path] = state;
  }

  return { root, tracked, files };
}

async function snapshotDirectory(ctx: ExtensionContext): Promise<string> {
  const directory = join(ctx.sessionManager.getSessionDir(), "undo");
  await mkdir(directory, { recursive: true });
  return mkdtemp(join(directory, `${ctx.sessionManager.getSessionId()}-`));
}

async function fileSnapshot(
  absolute: string,
  root: string,
  path: string,
): Promise<SnapshotFile> {
  let stats: Awaited<ReturnType<typeof lstat>>;
  try {
    stats = await lstat(absolute);
  } catch {
    return { exists: false };
  }

  if (stats.isSymbolicLink()) {
    return {
      exists: true,
      symlink: await readlink(absolute),
      mode: stats.mode,
    };
  }

  if (!stats.isFile()) return { exists: true, mode: stats.mode };

  const source = join(root, path);
  await mkdir(dirname(source), { recursive: true });
  await copyFile(absolute, source);
  return { exists: true, source, mode: stats.mode };
}

async function restoreSnapshot(
  pi: ExtensionAPI,
  cwd: string,
  target: WorkspaceSnapshot,
  other: WorkspaceSnapshot,
): Promise<void> {
  const paths = new Set([
    ...Object.keys(target.files),
    ...Object.keys(other.files),
  ]);
  for (const path of paths) {
    const absolute = safePath(cwd, path);
    const state = target.files[path];
    if (state?.exists) {
      await rm(absolute, { force: true, recursive: true });
      await mkdir(dirname(absolute), { recursive: true });

      if (state.source) {
        await copyFile(state.source, absolute);
      } else if (state.symlink) {
        await symlink(state.symlink, absolute);
      }

      if (state.mode !== undefined && !state.symlink) {
        await chmod(absolute, state.mode);
      }

      continue;
    }

    if (state && !state.exists) {
      await rm(absolute, { force: true, recursive: true });
      continue;
    }

    if (target.tracked.includes(path)) {
      const result = await pi.exec(
        "git",
        ["restore", "--worktree", "--source=HEAD", "--", path],
        {
          cwd,
          timeout: SNAPSHOT_TIMEOUT,
        },
      );

      if (result.code === 0) continue;
    }

    await rm(absolute, { force: true, recursive: true });
  }
}

async function moveTo(
  ctx: ExtensionCommandContext,
  entryId: string | null,
): Promise<void> {
  if (entryId) {
    const result = await ctx.navigateTree(entryId, { summarize: false });
    if (result.cancelled) throw new Error("Session navigation was cancelled");
    return;
  }

  const sessionManager = ctx.sessionManager as SessionManagerWithReset;
  sessionManager.resetLeaf();
}

function splitNul(value: string): string[] {
  return value.split("\0").filter(Boolean);
}

function safePath(cwd: string, path: string): string {
  const absolute = resolve(cwd, path);
  const relativePath = relative(cwd, absolute);
  if (relativePath === ".." || relativePath.startsWith(`..${sep}`)) {
    throw new Error(`Unsafe snapshot path: ${path}`);
  }

  return absolute;
}

function userPrompt(content: unknown): string {
  if (typeof content === "string") return content;
  if (!Array.isArray(content)) return "";
  return content
    .filter(
      (part): part is { type: "text"; text: string } =>
        isRecord(part) && part.type === "text" && typeof part.text === "string",
    )
    .map((part) => part.text)
    .join("");
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null;
}

function notify(
  ctx: ExtensionContext,
  message: string,
  level: "info" | "warning",
): void {
  if (ctx.hasUI) ctx.ui.notify(message, level);
}

function errorMessage(error: unknown): string {
  return error instanceof Error ? error.message : String(error);
}
