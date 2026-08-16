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

const MAX_RESPONSE_BYTES = 5 * 1024 * 1024;
const DEFAULT_TIMEOUT_SECONDS = 30;
const MAX_TIMEOUT_SECONDS = 120;
const BROWSER_USER_AGENT =
  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36";

const CLOUDFLARE_USER_AGENT = "opencode";
const MAX_CODE_POINT = 0x10ffff;
const SKIPPED_HTML_ELEMENTS = new Set([
  "script",
  "style",
  "noscript",
  "iframe",
  "object",
  "embed",
]);

const BLOCK_HTML_ELEMENTS = new Set([
  "address",
  "article",
  "aside",
  "blockquote",
  "br",
  "dd",
  "div",
  "dl",
  "dt",
  "figcaption",
  "figure",
  "footer",
  "form",
  "h1",
  "h2",
  "h3",
  "h4",
  "h5",
  "h6",
  "header",
  "hr",
  "li",
  "main",
  "nav",
  "ol",
  "option",
  "p",
  "pre",
  "section",
  "table",
  "tbody",
  "td",
  "tfoot",
  "th",
  "thead",
  "tr",
  "ul",
]);

const NAMED_HTML_ENTITIES: Record<string, string> = {
  amp: "&",
  apos: "'",
  gt: ">",
  lt: "<",
  nbsp: " ",
  quot: '"',
};

const TEXTUAL_MIME_TYPES = new Set([
  "application/json",
  "application/javascript",
  "application/x-javascript",
  "application/xml",
  "image/svg+xml",
]);

const parameters = Type.Object({
  url: Type.String({
    description: "The HTTP or HTTPS URL to fetch content from",
  }),
  format: Type.Optional(
    StringEnum(["text", "markdown", "html"] as const, {
      description: "The format to return the content in. Defaults to markdown.",
    }),
  ),
  timeout: Type.Optional(
    Type.Number({
      minimum: 1,
      maximum: MAX_TIMEOUT_SECONDS,
      description: `Optional timeout in seconds (maximum: ${MAX_TIMEOUT_SECONDS})`,
    }),
  ),
});

type FetchFormat = "text" | "markdown" | "html";

type WebFetchDetails = {
  url: string;
  contentType: string;
  format: FetchFormat;
  truncated?: boolean;
  fullOutputPath?: string;
};

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: "webfetch",
    label: "Web Fetch",
    description: `Fetch content from an HTTP or HTTPS URL and return it as text, markdown, or HTML. Markdown is the default.

Use a more targeted tool when one is available. This tool is read-only. Responses are limited to ${formatSize(MAX_RESPONSE_BYTES)} and tool output is truncated to ${DEFAULT_MAX_LINES} lines or ${formatSize(DEFAULT_MAX_BYTES)}.`,
    promptSnippet: "Fetch and convert content from an HTTP or HTTPS URL",
    parameters,

    async execute(_toolCallId, params, signal) {
      const format = params.format ?? "markdown";
      const url = parseHttpUrl(params.url);
      const { body, contentType } = await runEffect(
        tryPromise(() =>
          fetchBody(
            url.toString(),
            format,
            params.timeout ?? DEFAULT_TIMEOUT_SECONDS,
            signal,
          ),
        ),
      );

      const mime = mimeFrom(contentType);

      if (isImageAttachment(mime)) {
        return {
          content: [
            { type: "text", text: `Image fetched successfully from ${url}.` },
            {
              type: "image",
              data: Buffer.from(body).toString("base64"),
              mimeType: mime,
            },
          ],
          details: {
            url: url.toString(),
            contentType,
            format,
          } satisfies WebFetchDetails,
        };
      }

      if (!isTextualMime(mime)) {
        throw new Error(
          `Unsupported fetched file content type: ${mime || "unknown"}`,
        );
      }

      const source = new TextDecoder().decode(body);
      const output = convert(source, contentType, format);
      const truncation = truncateHead(output, {
        maxLines: DEFAULT_MAX_LINES,
        maxBytes: DEFAULT_MAX_BYTES,
      });

      const details: WebFetchDetails = {
        url: url.toString(),
        contentType,
        format,
      };

      let result = truncation.content;

      if (truncation.truncated) {
        const directory = await mkdtemp(join(tmpdir(), "pi-webfetch-"));
        const fullOutputPath = join(directory, "output.txt");
        await writeFile(fullOutputPath, output, "utf8");
        details.truncated = true;
        details.fullOutputPath = fullOutputPath;
        result += `\n\n[Output truncated: showing ${truncation.outputLines} of ${truncation.totalLines} lines (${formatSize(truncation.outputBytes)} of ${formatSize(truncation.totalBytes)}). Full output saved to: ${fullOutputPath}]`;
      }

      return {
        content: [{ type: "text", text: result }],
        details,
      };
    },
  });
}

async function fetchBody(
  url: string,
  format: FetchFormat,
  timeoutSeconds: number,
  signal: AbortSignal | undefined,
): Promise<{ body: Uint8Array; contentType: string }> {
  const timeoutController = new AbortController();
  const timeout = setTimeout(
    () => timeoutController.abort(),
    timeoutSeconds * 1000,
  );

  const requestSignal = signal
    ? AbortSignal.any([signal, timeoutController.signal])
    : timeoutController.signal;

  try {
    let response = await request(
      url,
      format,
      BROWSER_USER_AGENT,
      requestSignal,
    );

    if (isCloudflareChallenge(response)) {
      await response.body?.cancel();
      response = await request(
        url,
        format,
        CLOUDFLARE_USER_AGENT,
        requestSignal,
      );
    }

    if (!response.ok) {
      throw new Error(`Request failed with HTTP ${response.status}`);
    }

    const contentType = response.headers.get("content-type") ?? "";
    const declaredLength = Number(response.headers.get("content-length"));

    if (
      Number.isFinite(declaredLength) &&
      declaredLength > MAX_RESPONSE_BYTES
    ) {
      throw new Error(
        `Response too large (exceeds ${formatSize(MAX_RESPONSE_BYTES)} limit)`,
      );
    }

    return { body: await readBody(response, requestSignal), contentType };
  } catch (error) {
    if (timeoutController.signal.aborted && !signal?.aborted) {
      throw new Error("Request timed out");
    }

    throw error;
  } finally {
    clearTimeout(timeout);
  }
}

async function request(
  url: string,
  format: FetchFormat,
  userAgent: string,
  signal: AbortSignal,
): Promise<Response> {
  return fetch(url, {
    headers: {
      "User-Agent": userAgent,
      Accept: acceptHeader(format),
      "Accept-Language": "en-US,en;q=0.9",
    },
    signal,
  });
}

async function readBody(
  response: Response,
  signal: AbortSignal,
): Promise<Uint8Array> {
  if (!response.body) {
    const body = new Uint8Array(await response.arrayBuffer());
    if (body.byteLength > MAX_RESPONSE_BYTES) {
      throw new Error(
        `Response too large (exceeds ${formatSize(MAX_RESPONSE_BYTES)} limit)`,
      );
    }

    return body;
  }

  const reader = response.body.getReader();
  const chunks: Uint8Array[] = [];
  let size = 0;

  try {
    while (true) {
      signal.throwIfAborted();
      const { done, value } = await reader.read();
      if (done) break;
      if (!value) continue;
      size += value.byteLength;
      if (size > MAX_RESPONSE_BYTES) {
        throw new Error(
          `Response too large (exceeds ${formatSize(MAX_RESPONSE_BYTES)} limit)`,
        );
      }

      chunks.push(value);
    }
  } catch (error) {
    await reader.cancel().catch(() => {});
    throw error;
  }

  const body = new Uint8Array(size);
  let offset = 0;
  for (const chunk of chunks) {
    body.set(chunk, offset);
    offset += chunk.byteLength;
  }

  return body;
}

function parseHttpUrl(value: string): URL {
  let url: URL;
  try {
    url = new URL(value);
  } catch {
    throw new Error("URL must be a valid HTTP or HTTPS URL");
  }

  if (url.protocol !== "http:" && url.protocol !== "https:") {
    throw new Error("URL must use http:// or https://");
  }
  return url;
}

function acceptHeader(format: FetchFormat): string {
  if (format === "markdown") {
    return "text/markdown;q=1.0, text/x-markdown;q=0.9, text/plain;q=0.8, text/html;q=0.7, */*;q=0.1";
  }

  if (format === "text") {
    return "text/plain;q=1.0, text/markdown;q=0.9, text/html;q=0.8, */*;q=0.1";
  }

  return "text/html;q=1.0, application/xhtml+xml;q=0.9, text/plain;q=0.8, text/markdown;q=0.7, */*;q=0.1";
}

function isCloudflareChallenge(response: Response): boolean {
  return (
    response.status === 403 &&
    response.headers.get("cf-mitigated") === "challenge"
  );
}

function mimeFrom(contentType: string): string {
  return contentType.split(";", 1)[0]?.trim().toLowerCase() ?? "";
}

function isImageAttachment(mime: string): boolean {
  return (
    mime.startsWith("image/") &&
    mime !== "image/svg+xml" &&
    mime !== "image/vnd.fastbidsheet"
  );
}

function isTextualMime(mime: string): boolean {
  return (
    !mime ||
    mime.startsWith("text/") ||
    TEXTUAL_MIME_TYPES.has(mime) ||
    mime.endsWith("+json") ||
    mime.endsWith("+xml")
  );
}

function convert(
  content: string,
  contentType: string,
  format: FetchFormat,
): string {
  const mime = mimeFrom(contentType);
  if (mime !== "text/html" && mime !== "application/xhtml+xml") return content;
  if (format === "html") return content;
  if (format === "text") return extractTextFromHTML(content);
  return convertHTMLToMarkdown(content);
}

function extractTextFromHTML(html: string): string {
  let text = "";
  let skipDepth = 0;

  for (const token of html
    .replace(/<!--[\s\S]*?-->/g, "")
    .match(/<[^>]*>|[^<]+/g) ?? []) {
    const closing = /^<\s*\//.test(token);
    const tag = token.match(/^<\s*\/?\s*([\w-]+)/)?.[1]?.toLowerCase();
    if (!tag) {
      if (skipDepth === 0) text += decodeHtmlEntities(token);
      continue;
    }

    if (SKIPPED_HTML_ELEMENTS.has(tag)) {
      if (closing) {
        skipDepth = Math.max(0, skipDepth - 1);
      } else if (!token.endsWith("/>") && !/^<\s*(?:br|hr)\b/i.test(token)) {
        skipDepth++;
      }

      continue;
    }

    if (
      skipDepth === 0 &&
      BLOCK_HTML_ELEMENTS.has(tag) &&
      !text.endsWith("\n")
    ) {
      text += "\n";
    }
  }

  return text
    .replace(/[ \t]+\n/g, "\n")
    .replace(/\n{3,}/g, "\n\n")
    .trim();
}

function convertHTMLToMarkdown(html: string): string {
  let markdown = html.replace(/<!--[\s\S]*?-->/g, "");
  markdown = markdown.replace(
    /<\s*(script|style|meta|link)\b[^>]*>[\s\S]*?<\s*\/\1\s*>/gi,
    "",
  );

  markdown = markdown.replace(/<\s*br\s*\/?>/gi, "\n");
  markdown = markdown.replace(/<\s*hr\s*\/?>/gi, "\n\n---\n\n");
  markdown = markdown.replace(
    /<\s*h([1-6])\b[^>]*>([\s\S]*?)<\s*\/h\1\s*>/gi,
    (_tag, level: string, value: string) => {
      return `\n\n${"#".repeat(Number(level))} ${inlineMarkdown(value)}\n\n`;
    },
  );

  markdown = markdown.replace(
    /<\s*(?:p|div|section|article|header|footer|main|aside|blockquote)\b[^>]*>/gi,
    "\n\n",
  );

  markdown = markdown.replace(
    /<\s*\/(?:p|div|section|article|header|footer|main|aside|blockquote)\s*>/gi,
    "\n\n",
  );

  markdown = markdown.replace(/<\s*li\b[^>]*>/gi, "\n- ");
  markdown = markdown.replace(/<\s*\/li\s*>/gi, "\n");
  markdown = markdown.replace(
    /<\s*(strong|b)\b[^>]*>([\s\S]*?)<\s*\/\1\s*>/gi,
    "**$2**",
  );

  markdown = markdown.replace(
    /<\s*(em|i)\b[^>]*>([\s\S]*?)<\s*\/\1\s*>/gi,
    "*$2*",
  );

  markdown = markdown.replace(
    /<\s*code\b[^>]*>([\s\S]*?)<\s*\/code\s*>/gi,
    "`$1`",
  );

  markdown = markdown.replace(
    /<\s*a\b[^>]*href=["']([^"']+)["'][^>]*>([\s\S]*?)<\s*\/a\s*>/gi,
    "[$2]($1)",
  );

  markdown = markdown.replace(/<[^>]+>/g, "");
  markdown = decodeHtmlEntities(markdown)
    .replace(/[ \t]+\n/g, "\n")
    .replace(/\n{3,}/g, "\n\n");

  return markdown.trim();
}

function inlineMarkdown(value: string): string {
  return decodeHtmlEntities(value.replace(/<[^>]+>/g, "").trim());
}

function decodeHtmlEntities(value: string): string {
  return value.replace(
    /&(#x?[0-9a-f]+|amp|apos|gt|lt|nbsp|quot);/gi,
    (entity, reference: string) => {
      if (reference.toLowerCase().startsWith("#x")) {
        return codePoint(reference.slice(2), 16) ?? entity;
      }

      if (reference.startsWith("#")) {
        return codePoint(reference.slice(1), 10) ?? entity;
      }

      return NAMED_HTML_ENTITIES[reference.toLowerCase()] ?? entity;
    },
  );
}

function codePoint(digits: string, radix: number): string | undefined {
  const value = Number.parseInt(digits, radix);
  if (!Number.isInteger(value) || value < 0 || value > MAX_CODE_POINT) {
    return undefined;
  }

  return String.fromCodePoint(value);
}
