import type { Stats } from "node:fs";
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
import { dirname, isAbsolute, join, relative, resolve, sep } from "node:path";
import {
  type ExtensionAPI,
  type ExtensionCommandContext,
  type ExtensionContext,
  getAgentDir,
  type SessionEntry,
} from "@earendil-works/pi-coding-agent";

const STATE_TYPE = "pi-undo-redo";
const GIT_TIMEOUT = 30_000;

type SnapshotFile =
  | { kind: "missing" }
  | { kind: "file"; source: string; mode: number }
  | { kind: "symlink"; target: string }
  | { kind: "opaque" };

type WorkspaceSnapshot = {
  worktree: string;
  files: Record<string, SnapshotFile>;
};

type UndoRecord = {
  userEntryId: string;
  prompt: string;
  before: WorkspaceSnapshot;
  after: WorkspaceSnapshot;
};

type PersistedState = {
  kind: "record";
  record: UndoRecord;
};

type PendingTurn = {
  startLeafId: string | null;
  before: WorkspaceSnapshot;
};

type RedoEntry = {
  record: UndoRecord;
  leafId: string | null;
};

type UserEntry = {
  id: string;
  prompt: string;
};

export default function (pi: ExtensionAPI) {
  let history: UndoRecord[] = [];
  let redoStack: RedoEntry[] = [];
  let pending: PendingTurn | undefined;
  /** undefined = not resolved yet, null = cwd is not inside a Git worktree */
  let worktree: string | null | undefined;
  let warnedOutsideGit = false;

  async function snapshot(
    ctx: ExtensionContext,
  ): Promise<WorkspaceSnapshot | undefined> {
    if (worktree === undefined) worktree = await resolveWorktree(pi, ctx.cwd);
    if (worktree !== null) return captureSnapshot(pi, ctx, worktree);

    if (!warnedOutsideGit) {
      notify(ctx, "Undo is unavailable outside a Git worktree", "warning");
      warnedOutsideGit = true;
    }

    return undefined;
  }

  pi.on("session_start", (_event, ctx) => {
    history = [];
    redoStack = [];
    pending = undefined;
    worktree = undefined;
    warnedOutsideGit = false;
    for (const entry of ctx.sessionManager.getEntries()) {
      if (entry.type !== "custom" || entry.customType !== STATE_TYPE) continue;
      const data = entry.data as Partial<PersistedState> | undefined;
      if (data?.kind === "record" && data.record) history.push(data.record);
    }
  });

  pi.on("agent_start", async (_event, ctx) => {
    redoStack = [];
    if (pending) return;

    const startLeafId = ctx.sessionManager.getLeafId();
    try {
      const before = await snapshot(ctx);
      if (before) pending = { startLeafId, before };
    } catch (error) {
      notify(ctx, `Undo snapshot failed: ${errorMessage(error)}`, "warning");
    }
  });

  pi.on("agent_settled", async (_event, ctx) => {
    const current = pending;
    pending = undefined;
    if (!current) return;

    const entry = findTurnUserEntry(
      ctx.sessionManager.getBranch(),
      current.startLeafId,
    );
    if (!entry) return;

    try {
      const after = await snapshot(ctx);
      if (!after) return;
      const record: UndoRecord = {
        userEntryId: entry.id,
        prompt: entry.prompt,
        before: current.before,
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

      const record = findLastUndoable(history, branch);
      if (!record) {
        ctx.ui.notify("Nothing to undo", "warning");
        return;
      }

      const leafId = ctx.sessionManager.getLeafId();
      const navigated = await ctx.navigateTree(record.userEntryId, {
        summarize: false,
      });

      if (navigated.cancelled) {
        ctx.ui.notify("Undo cancelled", "warning");
        return;
      }

      await restoreSnapshot(pi, record.before, record.after);
      redoStack.push({ record, leafId });
      ctx.ui.setEditorText(record.prompt);
      ctx.ui.notify("Undid the last message and file changes", "info");
    },
  });

  pi.registerCommand("redo", {
    description: "Redo the last undone message and restore its file changes",
    handler: async (_args, ctx) => {
      await stopAgent(ctx);
      const entry = redoStack.at(-1);
      if (!entry) {
        ctx.ui.notify("Nothing to redo", "warning");
        return;
      }

      if (entry.leafId) {
        const navigated = await ctx.navigateTree(entry.leafId, {
          summarize: false,
        });
        if (navigated.cancelled) {
          ctx.ui.notify("Redo cancelled", "warning");
          return;
        }
      }

      await restoreSnapshot(pi, entry.record.after, entry.record.before);
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

function findTurnUserEntry(
  branch: SessionEntry[],
  startLeafId: string | null,
): UserEntry | undefined {
  const index = startLeafId
    ? branch.findIndex((entry) => entry.id === startLeafId)
    : -1;
  if (startLeafId && index === -1) return findLastUserEntry(branch);

  for (const entry of branch.slice(index + 1)) {
    const user = userEntry(entry);
    if (user) return user;
  }

  return undefined;
}

function findLastUserEntry(branch: SessionEntry[]): UserEntry | undefined {
  for (let index = branch.length - 1; index >= 0; index--) {
    const user = userEntry(branch[index]);
    if (user) return user;
  }

  return undefined;
}

function userEntry(entry: SessionEntry): UserEntry | undefined {
  if (entry.type !== "message") return undefined;
  if (!("role" in entry.message) || entry.message.role !== "user") {
    return undefined;
  }

  return { id: entry.id, prompt: userPrompt(entry.message.content) };
}

function findLastUndoable(
  records: UndoRecord[],
  branch: Set<string>,
): UndoRecord | undefined {
  for (let index = records.length - 1; index >= 0; index--) {
    const record = records[index];
    if (branch.has(record.userEntryId)) return record;
  }

  return undefined;
}

async function resolveWorktree(
  pi: ExtensionAPI,
  cwd: string,
): Promise<string | null> {
  const result = await pi.exec("git", ["rev-parse", "--show-toplevel"], {
    cwd,
    timeout: GIT_TIMEOUT,
  });

  if (result.code !== 0) return null;
  return result.stdout.trim() || null;
}

async function captureSnapshot(
  pi: ExtensionAPI,
  ctx: ExtensionContext,
  worktree: string,
): Promise<WorkspaceSnapshot> {
  const status = await pi.exec(
    "git",
    ["status", "--porcelain=v1", "-z", "--untracked-files=all", "--no-renames"],
    { cwd: worktree, timeout: GIT_TIMEOUT },
  );

  if (status.code !== 0) {
    throw new Error(`Unable to inspect Git worktree: ${status.stderr.trim()}`);
  }

  const excluded = [getAgentDir(), ctx.sessionManager.getSessionDir()];
  const paths = changedPaths(status.stdout).filter(
    (path) =>
      !excluded.some((root) => isInside(root, safePath(worktree, path))),
  );

  if (paths.length === 0) return { worktree, files: {} };

  const store = await snapshotStore(ctx);
  const files: Record<string, SnapshotFile> = {};
  for (const path of paths) {
    files[path] = await fileSnapshot(safePath(worktree, path), store, path);
  }

  return { worktree, files };
}

function changedPaths(status: string): string[] {
  return status
    .split("\0")
    .filter((record) => record.length > 3)
    .map((record) => record.slice(3));
}

async function snapshotStore(ctx: ExtensionContext): Promise<string> {
  const directory = join(ctx.sessionManager.getSessionDir(), "undo");
  await mkdir(directory, { recursive: true });
  return mkdtemp(join(directory, `${ctx.sessionManager.getSessionId()}-`));
}

async function fileSnapshot(
  absolute: string,
  store: string,
  path: string,
): Promise<SnapshotFile> {
  let stats: Stats;
  try {
    stats = await lstat(absolute);
  } catch {
    return { kind: "missing" };
  }

  if (stats.isSymbolicLink()) {
    return { kind: "symlink", target: await readlink(absolute) };
  }

  if (!stats.isFile()) return { kind: "opaque" };

  const source = join(store, path);
  await mkdir(dirname(source), { recursive: true });
  await copyFile(absolute, source);
  return { kind: "file", source, mode: stats.mode & 0o7777 };
}

async function restoreSnapshot(
  pi: ExtensionAPI,
  target: WorkspaceSnapshot,
  other: WorkspaceSnapshot,
): Promise<void> {
  await assertSnapshotIntact(target);
  const paths = new Set([
    ...Object.keys(target.files),
    ...Object.keys(other.files),
  ]);

  for (const path of paths) {
    const absolute = safePath(target.worktree, path);
    const state = target.files[path];
    if (state) {
      await restoreFile(absolute, state);
      continue;
    }

    const result = await pi.exec(
      "git",
      ["restore", "--staged", "--worktree", "--source=HEAD", "--", path],
      { cwd: target.worktree, timeout: GIT_TIMEOUT },
    );

    if (result.code !== 0) await rm(absolute, { force: true, recursive: true });
  }
}

async function assertSnapshotIntact(target: WorkspaceSnapshot): Promise<void> {
  for (const state of Object.values(target.files)) {
    if (state.kind !== "file") continue;
    try {
      await lstat(state.source);
    } catch {
      throw new Error(`Undo snapshot is incomplete: ${state.source} is gone`);
    }
  }
}

async function restoreFile(
  absolute: string,
  state: SnapshotFile,
): Promise<void> {
  if (state.kind === "opaque") return;

  await rm(absolute, { force: true, recursive: true });
  if (state.kind === "missing") return;

  await mkdir(dirname(absolute), { recursive: true });
  if (state.kind === "symlink") {
    await symlink(state.target, absolute);
    return;
  }

  await copyFile(state.source, absolute);
  await chmod(absolute, state.mode);
}

function safePath(worktree: string, path: string): string {
  const absolute = resolve(worktree, path);
  if (!isInside(worktree, absolute)) {
    throw new Error(`Unsafe snapshot path: ${path}`);
  }

  return absolute;
}

function isInside(root: string, absolute: string): boolean {
  const relativePath = relative(root, absolute);
  return (
    relativePath === "" ||
    (!isAbsolute(relativePath) &&
      relativePath !== ".." &&
      !relativePath.startsWith(`..${sep}`))
  );
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
