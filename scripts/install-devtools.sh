#!/usr/bin/env bash

set -euo pipefail

log() { printf "\033[1;34m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }

if ! command -v uv &>/dev/null; then
    log "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    log "Astral-uv already installed"
fi

if ! command -v cargo &>/dev/null; then
    log "Installing cargo via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
    log "Cargo already installed"
fi

if ! command -v pnpm &>/dev/null; then
    log "Installing pnpm..."
    curl -fsSL https://get.pnpm.io/install.sh | sh -
else
    log "Pnpm already installed"
fi

if ! command -v opencode &>/dev/null; then
    log "Installing opencode..."
    curl -fsSL https://opencode.ai/install.sh | sh
else
    log "Opencode already installed"
fi

log "Devtools installed"
