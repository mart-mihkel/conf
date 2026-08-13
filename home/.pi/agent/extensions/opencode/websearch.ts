import { mkdtemp, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { StringEnum, Type } from "@earendil-works/pi-ai";
import {
  DEFAULT_MAX_BYTES,
  DEFAULT_MAX_LINES,
  type ExtensionAPI,
  formatSize,
  truncateHead,
} from "@earendil-works/pi-coding-agent";
import { runEffect, tryPromise } from "../lib/effect.js";

const EXA_URL = "https://mcp.exa.ai/mcp";
const PARALLEL_URL = "https://search.parallel.ai/mcp";
const MAX_NUM_RESULTS = 20;
const MAX_CONTEXT_CHARACTERS = 50_000;
const MAX_RESPONSE_BYTES = 256 * 1024;
const REQUEST_TIMEOUT_SECONDS = 25;
const NO_RESULTS = "No search results found. Please try a different query.";

const parameters = Type.Object({
  query: Type.String({ description: "Web search query" }),
  numResults: Type.Optional(
    Type.Integer({
      minimum: 1,
      maximum: MAX_NUM_RESULTS,
      description: `Number of search results to return (default: 8, maximum: ${MAX_NUM_RESULTS})`,
    }),
  ),
  livecrawl: Type.Optional(
    StringEnum(["fallback", "preferred"] as const, {
      description: "Live crawl mode. Defaults to fallback.",
    }),
  ),
  type: Type.Optional(
    StringEnum(["auto", "fast", "deep"] as const, {
      description: "Search type. Defaults to auto.",
    }),
  ),
  contextMaxCharacters: Type.Optional(
    Type.Integer({
      minimum: 1,
      maximum: MAX_CONTEXT_CHARACTERS,
      description: `Maximum characters in the context string (default: 10000, maximum: ${MAX_CONTEXT_CHARACTERS})`,
    }),
  ),
});

type Provider = "exa" | "parallel";
type WebSearchDetails = {
  provider: Provider;
  truncated?: boolean;
  fullOutputPath?: string;
};

type McpContent = { type?: unknown; text?: unknown };

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: "websearch",
    label: "Web Search",
    description: `Search the web using Exa or Parallel for current information beyond the model's knowledge cutoff. Search results include relevant web content.

The current year is ${new Date().getFullYear()}. Include it when searching for recent information or current events. Supports result count, live crawling, search type, and context length controls. Responses are truncated to ${DEFAULT_MAX_LINES} lines or ${formatSize(DEFAULT_MAX_BYTES)} when necessary.`,
    promptSnippet:
      "Search the web for current information and relevant sources",
    promptGuidelines: [
      "Use websearch for current information, recent events, or facts beyond the model's knowledge cutoff.",
      "Use webfetch to read a specific URL when a search result needs deeper inspection.",
    ],
    parameters,

    async execute(_toolCallId, params, signal, _onUpdate, ctx) {
      const sessionId = ctx.sessionManager.getSessionId();
      const provider = selectProvider(sessionId);
      const response = await runEffect(
        tryPromise(() => callProvider(provider, params, sessionId, signal)),
      );

      const output = response ?? NO_RESULTS;
      const truncation = truncateHead(output, {
        maxLines: DEFAULT_MAX_LINES,
        maxBytes: DEFAULT_MAX_BYTES,
      });

      let result = truncation.content;
      const details: WebSearchDetails = { provider };

      if (truncation.truncated) {
        const directory = await mkdtemp(join(tmpdir(), "pi-websearch-"));
        const fullOutputPath = join(directory, "output.txt");
        await writeFile(fullOutputPath, output, "utf8");
        details.truncated = true;
        details.fullOutputPath = fullOutputPath;
        result += `\n\n[Search results truncated: showing ${truncation.outputLines} of ${truncation.totalLines} lines (${formatSize(truncation.outputBytes)} of ${formatSize(truncation.totalBytes)}). Full results saved to: ${fullOutputPath}]`;
      }

      return {
        content: [{ type: "text", text: result }],
        details,
      };
    },
  });
}

function selectProvider(sessionId: string): Provider {
  const override = process.env.OPENCODE_WEBSEARCH_PROVIDER;
  if (override === "exa" || override === "parallel") return override;

  let hash = 0x811c9dc5;
  for (const character of sessionId) {
    hash ^= character.charCodeAt(0);
    hash = Math.imul(hash, 0x01000193);
  }

  return Number.parseInt((hash >>> 0).toString(36), 36) % 2 === 0
    ? "exa"
    : "parallel";
}

async function callProvider(
  provider: Provider,
  params: {
    query: string;
    numResults?: number;
    livecrawl?: "fallback" | "preferred";
    type?: "auto" | "fast" | "deep";
    contextMaxCharacters?: number;
  },
  sessionId: string,
  signal: AbortSignal | undefined,
): Promise<string | undefined> {
  const url = provider === "exa" ? exaUrl() : PARALLEL_URL;
  const tool = provider === "exa" ? "web_search_exa" : "web_search";
  const args =
    provider === "exa"
      ? {
          query: params.query,
          type: params.type ?? "auto",
          numResults: params.numResults ?? 8,
          livecrawl: params.livecrawl ?? "fallback",
          contextMaxCharacters: params.contextMaxCharacters,
        }
      : {
          objective: params.query,
          search_queries: [params.query],
          session_id: sessionId,
        };

  const headers: Record<string, string> = {
    Accept: "application/json, text/event-stream",
    "Content-Type": "application/json",
    "User-Agent": "pi-websearch",
  };

  const apiKey =
    provider === "parallel" ? process.env.PARALLEL_API_KEY : undefined;

  if (apiKey) headers.Authorization = `Bearer ${apiKey}`;

  const timeoutController = new AbortController();
  const timeout = setTimeout(
    () => timeoutController.abort(),
    REQUEST_TIMEOUT_SECONDS * 1000,
  );

  const requestSignal = signal
    ? AbortSignal.any([signal, timeoutController.signal])
    : timeoutController.signal;

  try {
    const response = await fetch(url, {
      method: "POST",
      headers,
      body: JSON.stringify({
        jsonrpc: "2.0",
        id: 1,
        method: "tools/call",
        params: { name: tool, arguments: args },
      }),
      signal: requestSignal,
    });

    if (!response.ok) {
      throw new Error(`Request failed with HTTP ${response.status}`);
    }

    const body = await readBody(response, requestSignal);
    return parseResponse(new TextDecoder().decode(body));
  } catch (error) {
    if (timeoutController.signal.aborted && !signal?.aborted) {
      throw new Error(`${tool} request timed out`);
    }

    if (signal?.aborted) throw error;
    throw new Error(`Unable to search the web for ${params.query}`);
  } finally {
    clearTimeout(timeout);
  }
}

function exaUrl(): string {
  const url = new URL(EXA_URL);
  const apiKey = process.env.EXA_API_KEY;
  if (apiKey) url.searchParams.set("exaApiKey", apiKey);
  return url.toString();
}

async function readBody(
  response: Response,
  signal: AbortSignal,
): Promise<Uint8Array> {
  if (!response.body) {
    const body = new Uint8Array(await response.arrayBuffer());
    if (body.byteLength > MAX_RESPONSE_BYTES) {
      throw new Error("Search response exceeded the byte limit");
    }

    return body;
  }

  const reader = response.body.getReader();
  const chunks: Uint8Array[] = [];
  let size = 0;

  while (true) {
    signal.throwIfAborted();
    const { done, value } = await reader.read();
    if (done) break;
    if (!value) continue;

    size += value.byteLength;
    if (size > MAX_RESPONSE_BYTES) {
      await reader.cancel();
      throw new Error("Search response exceeded the byte limit");
    }

    chunks.push(value);
  }

  const body = new Uint8Array(size);
  let offset = 0;
  for (const chunk of chunks) {
    body.set(chunk, offset);
    offset += chunk.byteLength;
  }

  return body;
}

function parseResponse(body: string): string | undefined {
  const direct = parsePayload(body);
  if (direct) return direct;

  for (const line of body.split("\n")) {
    if (!line.startsWith("data: ")) continue;
    const data = parsePayload(line.slice(6));
    if (data) return data;
  }

  return undefined;
}

function parsePayload(payload: string): string | undefined {
  const trimmed = payload.trim();
  if (!trimmed.startsWith("{")) return undefined;

  let value: unknown;
  try {
    value = JSON.parse(trimmed);
  } catch {
    return undefined;
  }

  if (
    !isRecord(value) ||
    !isRecord(value.result) ||
    !Array.isArray(value.result.content)
  ) {
    return undefined;
  }

  const content = value.result.content as McpContent[];
  const item = content.find((entry) => typeof entry.text === "string");
  return typeof item?.text === "string" ? item.text : undefined;
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null;
}
