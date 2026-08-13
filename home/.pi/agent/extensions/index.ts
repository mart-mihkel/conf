import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import mcp from "./opencode/mcp.js";
import undoRedo from "./opencode/undo-redo.js";
import webfetch from "./opencode/webfetch.js";
import websearch from "./opencode/websearch.js";

export default function (pi: ExtensionAPI): void {
  webfetch(pi);
  websearch(pi);
  mcp(pi);
  undoRedo(pi);
}
