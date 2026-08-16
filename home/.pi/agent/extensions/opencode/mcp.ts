import { mkdtemp, readFile, writeFile } from "node:fs/promises";
import { homedir, tmpdir } from "node:os";
import { dirname, join, resolve } from "node:path";
import { Type } from "@earendil-works/pi-ai";
import {
  DEFAULT_MAX_BYTES,
  DEFAULT_MAX_LINES,
  type ExtensionAPI,
  formatSize,
  truncateHead,
} from "@earendil-works/pi-coding-agent";
import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import {
  getDefaultEnvironment,
  StdioClientTransport,
} from "@modelcontextprotocol/sdk/client/stdio.js";
import { StreamableHTTPClientTransport } from "@modelcontextprotocol/sdk/client/streamableHttp.js";
import type { Transport } from "@modelcontextprotocol/sdk/shared/transport.js";
import {
  type CallToolResult,
  CallToolResultSchema,
  type Tool,
} from "@modelcontextprotocol/sdk/types.js";
import { runEffect, tryPromise } from "../lib/effect.js";

const DEFAULT_REQUEST_TIMEOUT = 5_000;
const DEFAULT_STARTUP_TIMEOUT = 60_000;
const MAX_LIST_PAGES = 1_000;

const INHERITED_ENVIRONMENT = [
  "COLORTERM",
  "HTTPS_PROXY",
  "HTTP_PROXY",
  "LANG",
  "LC_ALL",
  "LC_CTYPE",
  "NODE_EXTRA_CA_CERTS",
  "NO_PROXY",
  "SSL_CERT_DIR",
  "SSL_CERT_FILE",
  "TMPDIR",
  "TZ",
  "XDG_CACHE_HOME",
  "XDG_CONFIG_HOME",
  "XDG_DATA_HOME",
  "http_proxy",
  "https_proxy",
  "no_proxy",
];

const CLIENT_NAME = "pi-opencode-mcp";
const CLIENT_VERSION = "1.0.0";

type ServerConfig = LocalServerConfig | RemoteServerConfig;

type LocalServerConfig = {
  type: "local";
  command: string[];
  cwd?: string;
  environment?: Record<string, string>;
  enabled?: boolean;
  disabled?: boolean;
  timeout?: number | { startup?: number; request?: number };
};

type RemoteServerConfig = {
  type: "remote";
  url: string;
  headers?: Record<string, string>;
  enabled?: boolean;
  disabled?: boolean;
  timeout?: number | { startup?: number; request?: number };
};

type Connection = {
  client: Client;
  transport: Transport;
  requestTimeout: number;
};

type McpDetails = {
  server: string;
  tool?: string;
  truncated?: boolean;
  fullOutputPath?: string;
};

type ConfigFile = { path: string; text: string };
type ConfigLoad = {
  configs: Record<string, ServerConfig>;
  errors: string[];
};

type TextBlock = { type: "text"; text: string };
type ImageBlock = { type: "image"; data: string; mimeType: string };
type PiBlock = TextBlock | ImageBlock;
type McpCallResult = CallToolResult | { toolResult: unknown };

export default function (pi: ExtensionAPI) {
  const connections = new Map<string, Connection>();
  let instructions: string[] = [];

  registerResourceTools(pi, connections);

  pi.on("session_start", async (_event, ctx) => {
    instructions = [];

    const { configs, errors } = await loadServerConfigs(ctx.cwd);
    for (const error of errors) {
      if (ctx.hasUI) ctx.ui.notify(`MCP config skipped — ${error}`, "warning");
    }

    const results = await Promise.all(
      Object.entries(configs).map(async ([name, config]) =>
        connectServer(name, config, ctx.cwd),
      ),
    );

    for (const result of results) {
      if (!result.connection) {
        if (result.error !== "disabled" && ctx.hasUI) {
          ctx.ui.notify(
            `MCP server ${result.name}: ${result.error}`,
            "warning",
          );
        }

        continue;
      }

      const connection = result.connection;
      try {
        const tools = await runEffect(tryPromise(() => listTools(connection)));
        connections.set(result.name, connection);

        if (connection.client.getInstructions()) {
          instructions.push(
            `<mcp_instructions server="${result.name}">\n${connection.client.getInstructions()}\n</mcp_instructions>`,
          );
        }

        for (const tool of tools) {
          registerMcpTool(pi, result.name, connection, tool);
        }

        if (ctx.hasUI) {
          ctx.ui.notify(
            `MCP server ${result.name}: ${tools.length} tool${tools.length === 1 ? "" : "s"} loaded`,
            "info",
          );
        }
      } catch (error) {
        await connection.client
          .close()
          .catch(() => connection.transport.close().catch(() => {}));

        if (ctx.hasUI) {
          ctx.ui.notify(
            `MCP server ${result.name}: ${errorMessage(error)}`,
            "warning",
          );
        }
      }
    }
  });

  pi.on("before_agent_start", (event) => {
    if (instructions.length === 0) return;
    return {
      systemPrompt: `${event.systemPrompt}\n\n${instructions.join("\n\n")}`,
    };
  });

  pi.on("session_shutdown", async () => {
    await closeConnections(connections);
    instructions = [];
  });
}

function registerResourceTools(
  pi: ExtensionAPI,
  connections: Map<string, Connection>,
) {
  pi.registerTool({
    name: "list_mcp_resources",
    label: "List MCP Resources",
    description:
      "List resources exposed by connected MCP servers. Use the exact server and URI returned before reading a resource.",
    parameters: Type.Object({
      server: Type.Optional(
        Type.String({ description: "Optional MCP server name" }),
      ),
    }),
    async execute(_toolCallId, params) {
      const selected = selectConnections(connections, params.server);
      const resources = await Promise.all(
        selected.map(async ([server, connection]) => ({
          server,
          resources: await paginate(
            (cursor) =>
              connection.client.listResources(cursor ? { cursor } : undefined, {
                timeout: connection.requestTimeout,
              }),
            (page) => page.resources,
          ),
        })),
      );

      return textResult(JSON.stringify(resources, null, 2), {
        server: params.server ?? "*",
      });
    },
  });

  pi.registerTool({
    name: "list_mcp_resource_templates",
    label: "List MCP Resource Templates",
    description: "List URI templates exposed by connected MCP servers.",
    parameters: Type.Object({
      server: Type.Optional(
        Type.String({ description: "Optional MCP server name" }),
      ),
    }),
    async execute(_toolCallId, params) {
      const selected = selectConnections(connections, params.server);
      const templates = await Promise.all(
        selected.map(async ([server, connection]) => ({
          server,
          templates: await paginate(
            (cursor) =>
              connection.client.listResourceTemplates(
                cursor ? { cursor } : undefined,
                {
                  timeout: connection.requestTimeout,
                },
              ),
            (page) => page.resourceTemplates,
          ),
        })),
      );

      return textResult(JSON.stringify(templates, null, 2), {
        server: params.server ?? "*",
      });
    },
  });

  pi.registerTool({
    name: "read_mcp_resource",
    label: "Read MCP Resource",
    description:
      "Read a resource from an MCP server using the exact server name and URI returned by list_mcp_resources.",
    parameters: Type.Object({
      server: Type.String({ description: "MCP server name" }),
      uri: Type.String({ description: "Exact MCP resource URI" }),
    }),
    async execute(_toolCallId, params) {
      const connection = requireConnection(connections, params.server);
      const result = await connection.client.readResource(
        { uri: params.uri },
        { timeout: connection.requestTimeout },
      );

      const blocks: PiBlock[] = [];
      for (const content of result.contents) {
        if ("text" in content) {
          blocks.push({
            type: "text",
            text: `${content.uri}\n${content.text}`,
          });
          continue;
        }

        if (content.mimeType?.startsWith("image/")) {
          blocks.push({
            type: "image",
            data: content.blob,
            mimeType: content.mimeType,
          });
          continue;
        }

        blocks.push({
          type: "text",
          text: `${content.uri}\n[Binary resource: ${content.mimeType ?? "unknown"}]`,
        });
      }

      const textBlocks = blocks.filter(
        (block): block is TextBlock => block.type === "text",
      );

      if (textBlocks.length === 0) {
        return {
          content: blocks,
          details: { server: params.server } satisfies McpDetails,
        };
      }

      const images = blocks.filter(
        (block): block is ImageBlock => block.type === "image",
      );

      const normalized = await textResult(
        textBlocks.map((block) => block.text).join("\n\n"),
        {
          server: params.server,
        },
      );

      return {
        content: [...normalized.content, ...images],
        details: normalized.details,
      };
    },
  });

  pi.registerTool({
    name: "get_mcp_prompt",
    label: "Get MCP Prompt",
    description: "Get a prompt template from an MCP server.",
    parameters: Type.Object({
      server: Type.String({ description: "MCP server name" }),
      name: Type.String({ description: "MCP prompt name" }),
      arguments: Type.Optional(Type.Record(Type.String(), Type.String())),
    }),
    async execute(_toolCallId, params) {
      const connection = requireConnection(connections, params.server);
      const result = await connection.client.getPrompt(
        { name: params.name, arguments: params.arguments },
        { timeout: connection.requestTimeout },
      );

      const text = result.messages
        .map((message) =>
          message.content.type === "text"
            ? `${message.role}: ${message.content.text}`
            : `[${message.content.type} content]`,
        )
        .join("\n\n");

      return textResult(
        text || result.description || "MCP prompt returned no messages",
        {
          server: params.server,
        },
      );
    },
  });
}

function registerMcpTool(
  pi: ExtensionAPI,
  server: string,
  connection: Connection,
  definition: Tool,
) {
  const name = `${sanitize(server)}_${sanitize(definition.name)}`;
  const parameters = Type.Unsafe<Record<string, unknown>>({
    ...definition.inputSchema,
    type: "object",
    additionalProperties: definition.inputSchema.additionalProperties ?? false,
  });

  pi.registerTool({
    name,
    label: `${server}: ${definition.title ?? definition.name}`,
    description:
      definition.description ?? `MCP tool ${definition.name} from ${server}`,
    parameters,
    async execute(_toolCallId, params, signal) {
      const result = await connection.client.callTool(
        { name: definition.name, arguments: params },
        CallToolResultSchema,
        {
          signal,
          timeout: connection.requestTimeout,
          resetTimeoutOnProgress: true,
          onprogress: () => {},
        },
      );

      if (!("content" in result)) {
        return await mcpResult(result, server, definition.name);
      }

      const toolResult = result as CallToolResult;
      if (toolResult.isError) {
        const message = toolResult.content
          .flatMap((content) => (content.type === "text" ? [content.text] : []))
          .filter((text) => text.trim())
          .join("\n\n");

        throw new Error(message || "MCP tool returned an error");
      }

      return await mcpResult(toolResult, server, definition.name);
    },
  });
}

async function connectServer(
  name: string,
  config: ServerConfig,
  cwd: string,
): Promise<{ name: string; connection?: Connection; error?: string }> {
  if (config.enabled === false || config.disabled === true) {
    return { name, error: "disabled" };
  }

  const startupTimeout = timeoutValue(config.timeout, "startup");
  const requestTimeout = timeoutValue(config.timeout, "request");
  let transport: Transport | undefined;

  try {
    const connectedClient = new Client({
      name: CLIENT_NAME,
      version: CLIENT_VERSION,
    });

    const connectedTransport = createTransport(config, cwd);
    transport = connectedTransport;
    await runEffect(
      tryPromise(() =>
        connectedClient.connect(connectedTransport, {
          timeout: startupTimeout,
        }),
      ),
    );

    return {
      name,
      connection: {
        client: connectedClient,
        transport: connectedTransport,
        requestTimeout,
      },
    };
  } catch (error) {
    if (transport) await transport.close().catch(() => {});
    return { name, error: errorMessage(error) };
  }
}

function createTransport(config: ServerConfig, cwd: string): Transport {
  if (config.type === "remote") {
    return new StreamableHTTPClientTransport(new URL(resolveEnv(config.url)), {
      requestInit: { headers: resolveValues(config.headers) },
    });
  }

  const [command, ...args] = config.command.map(resolveEnv);
  if (!command) throw new Error("local MCP server command is empty");
  return new StdioClientTransport({
    command,
    args,
    cwd: config.cwd ? resolve(cwd, resolveEnv(config.cwd)) : cwd,
    env: serverEnvironment(config.environment),
  });
}

async function listTools(connection: Connection): Promise<Tool[]> {
  return paginate(
    (cursor) =>
      connection.client.listTools(cursor ? { cursor } : undefined, {
        timeout: connection.requestTimeout,
      }),
    (page) => page.tools,
  );
}

async function paginate<T, Page extends { nextCursor?: string }>(
  request: (cursor?: string) => Promise<Page>,
  items: (page: Page) => T[],
): Promise<T[]> {
  const result: T[] = [];
  const cursors = new Set<string>();
  let cursor: string | undefined;

  for (let page = 0; page < MAX_LIST_PAGES; page++) {
    const response = await request(cursor);
    result.push(...items(response));
    if (!response.nextCursor) return result;
    if (cursors.has(response.nextCursor)) {
      throw new Error("MCP list returned duplicate cursor");
    }

    cursors.add(response.nextCursor);
    cursor = response.nextCursor;
  }

  throw new Error("MCP list exceeded the page limit");
}

function selectConnections(
  connections: Map<string, Connection>,
  server: string | undefined,
): Array<[string, Connection]> {
  if (server) return [[server, requireConnection(connections, server)]];
  return [...connections.entries()];
}

function requireConnection(
  connections: Map<string, Connection>,
  server: string,
): Connection {
  const connection = connections.get(server);
  if (!connection) throw new Error(`MCP server is not connected: ${server}`);
  return connection;
}

async function mcpResult(
  result: McpCallResult,
  server: string,
  tool: string,
): Promise<{ content: PiBlock[]; details: McpDetails }> {
  if (!("content" in result)) {
    return textResult(JSON.stringify(result), { server, tool });
  }

  const toolResult = result as CallToolResult;
  const blocks: PiBlock[] = [];
  const text: string[] = [];
  const details: McpDetails = { server, tool };
  for (const content of toolResult.content) {
    if (content.type === "text") {
      text.push(content.text);
      continue;
    }

    if (content.type === "image") {
      blocks.push({
        type: "image",
        data: content.data,
        mimeType: content.mimeType,
      });

      continue;
    }

    if (content.type === "resource") {
      if ("text" in content.resource) {
        text.push(`${content.resource.uri}\n${content.resource.text}`);
      } else {
        blocks.push({
          type: "text",
          text: `${content.resource.uri}\n[Binary MCP resource]`,
        });
      }

      continue;
    }

    if (content.type === "resource_link") {
      text.push(`${content.name}: ${content.uri}`);
      continue;
    }

    text.push(`[Unsupported MCP content: ${content.type}]`);
  }

  if (text.length > 0) {
    const resultText = text.join("\n\n");
    const truncated = truncateHead(resultText, {
      maxLines: DEFAULT_MAX_LINES,
      maxBytes: DEFAULT_MAX_BYTES,
    });

    let output = truncated.content;
    if (truncated.truncated) {
      const directory = await mkdtemp(join(tmpdir(), "pi-mcp-"));
      const fullOutputPath = join(directory, "output.txt");
      await writeFile(fullOutputPath, resultText, "utf8");
      details.truncated = true;
      details.fullOutputPath = fullOutputPath;
      output += `\n\n[MCP output truncated: showing ${truncated.outputLines} of ${truncated.totalLines} lines (${formatSize(truncated.outputBytes)} of ${formatSize(truncated.totalBytes)}). Full output saved to: ${fullOutputPath}]`;
    }

    blocks.unshift({ type: "text", text: output });
  }

  if (blocks.length === 0 && toolResult.structuredContent) {
    blocks.push({
      type: "text",
      text: JSON.stringify(toolResult.structuredContent),
    });
  }

  if (blocks.length === 0) {
    blocks.push({ type: "text", text: "MCP tool returned no content" });
  }

  return { content: blocks, details };
}

async function textResult(text: string, details: McpDetails) {
  const truncated = truncateHead(text, {
    maxLines: DEFAULT_MAX_LINES,
    maxBytes: DEFAULT_MAX_BYTES,
  });

  if (!truncated.truncated) {
    return {
      content: [{ type: "text" as const, text: truncated.content }],
      details,
    };
  }

  const directory = await mkdtemp(join(tmpdir(), "pi-mcp-"));
  const fullOutputPath = join(directory, "output.txt");
  await writeFile(fullOutputPath, text, "utf8");
  return {
    content: [
      {
        type: "text" as const,
        text: `${truncated.content}\n\n[Output truncated. Full output saved to: ${fullOutputPath}]`,
      },
    ],
    details: { ...details, truncated: true, fullOutputPath },
  };
}

async function closeConnections(
  connections: Map<string, Connection>,
): Promise<void> {
  const active = [...connections.values()];
  connections.clear();
  await Promise.all(
    active.map((connection) =>
      connection.client
        .close()
        .catch(() => connection.transport.close().catch(() => {})),
    ),
  );
}

async function loadServerConfigs(cwd: string): Promise<ConfigLoad> {
  const configs: Record<string, ServerConfig> = {};
  const errors: string[] = [];

  for (const file of await configFiles(cwd)) {
    let parsed: unknown;
    try {
      parsed = parseJsonc(file.text);
    } catch (error) {
      errors.push(`${file.path}: ${errorMessage(error)}`);
      continue;
    }

    for (const [name, value] of Object.entries(mcpEntries(parsed))) {
      if (isServerConfig(value)) configs[name] = value;
    }
  }

  return { configs, errors };
}

async function configFiles(cwd: string): Promise<ConfigFile[]> {
  const paths: string[] = [];
  const globalDirectory =
    process.env.OPENCODE_CONFIG_DIR ??
    join(process.env.XDG_CONFIG_HOME ?? join(homedir(), ".config"), "opencode");

  for (const filename of ["opencode.json", "opencode.jsonc"]) {
    paths.push(join(globalDirectory, filename));
  }

  const directories: string[] = [];
  let directory = resolve(cwd);
  while (true) {
    directories.unshift(directory);
    const parent = dirname(directory);
    if (parent === directory) break;
    directory = parent;
  }

  for (const item of directories) {
    for (const filename of ["opencode.json", "opencode.jsonc"]) {
      paths.push(join(item, filename));
    }

    for (const filename of ["opencode.json", "opencode.jsonc"]) {
      paths.push(join(item, ".opencode", filename));
    }
  }

  const files: ConfigFile[] = [];
  const seen = new Set<string>();
  for (const filepath of paths) {
    if (seen.has(filepath)) continue;
    seen.add(filepath);
    try {
      files.push({ path: filepath, text: await readFile(filepath, "utf8") });
    } catch {}
  }

  return files;
}

function mcpEntries(value: unknown): Record<string, unknown> {
  if (!isRecord(value) || !isRecord(value.mcp)) return {};
  if (isRecord(value.mcp.servers)) return value.mcp.servers;
  return value.mcp;
}

function isServerConfig(value: unknown): value is ServerConfig {
  if (!isRecord(value) || (value.type !== "local" && value.type !== "remote")) {
    return false;
  }

  if (value.type === "local") {
    return (
      Array.isArray(value.command) &&
      value.command.every((item) => typeof item === "string")
    );
  }

  return typeof value.url === "string";
}

function parseJsonc(text: string): unknown {
  return JSON.parse(removeTrailingCommas(removeComments(text)));
}

function removeComments(text: string): string {
  let output = "";
  let inString = false;

  for (let index = 0; index < text.length; index++) {
    const character = text[index];
    if (inString) {
      output += character;
      if (character === "\\") output += text[++index] ?? "";
      else if (character === '"') inString = false;
      continue;
    }

    if (character === '"') {
      inString = true;
      output += character;
      continue;
    }

    if (character === "/" && text[index + 1] === "/") {
      while (index < text.length && text[index] !== "\n") index++;
      output += "\n";
      continue;
    }

    if (character === "/" && text[index + 1] === "*") {
      index += 2;
      while (index < text.length && !isCommentEnd(text, index)) index++;
      index++;
      continue;
    }

    output += character;
  }

  return output;
}

function isCommentEnd(text: string, index: number): boolean {
  return text[index] === "*" && text[index + 1] === "/";
}

function removeTrailingCommas(text: string): string {
  let output = "";
  let inString = false;

  for (let index = 0; index < text.length; index++) {
    const character = text[index];
    if (inString) {
      output += character;
      if (character === "\\") output += text[++index] ?? "";
      else if (character === '"') inString = false;
      continue;
    }

    if (character === '"') inString = true;
    if (character === "," && closesNext(text, index)) continue;
    output += character;
  }

  return output;
}

function closesNext(text: string, index: number): boolean {
  let next = index + 1;
  while (next < text.length && /\s/.test(text[next] ?? "")) next++;
  return text[next] === "}" || text[next] === "]";
}

function resolveEnv(value: string): string {
  return value.replace(
    /\{env:([^}]+)\}/g,
    (_match, name: string) => process.env[name] ?? "",
  );
}

function resolveValues(
  values: Record<string, string> | undefined,
): Record<string, string> {
  return Object.fromEntries(
    Object.entries(values ?? {}).map(([key, value]) => [
      key,
      resolveEnv(value),
    ]),
  );
}

function serverEnvironment(
  environment: Record<string, string> | undefined,
): Record<string, string> {
  const inherited: Record<string, string> = getDefaultEnvironment();
  for (const name of INHERITED_ENVIRONMENT) {
    const value = process.env[name];
    if (value !== undefined) inherited[name] = value;
  }

  return { ...inherited, ...resolveValues(environment) };
}

function timeoutValue(
  timeout: ServerConfig["timeout"],
  key: "startup" | "request",
): number {
  if (typeof timeout === "number") return timeout;
  if (timeout && typeof timeout[key] === "number") return timeout[key];
  return key === "startup" ? DEFAULT_STARTUP_TIMEOUT : DEFAULT_REQUEST_TIMEOUT;
}

function sanitize(value: string): string {
  return value.replace(/[^a-zA-Z0-9_-]/g, "_");
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null;
}

function errorMessage(error: unknown): string {
  return error instanceof Error ? error.message : String(error);
}
