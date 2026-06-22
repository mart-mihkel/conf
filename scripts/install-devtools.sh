#!/usr/bin/env bash

set -euo pipefail

log() { printf "\033[1;34m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }

TMPDIR="$(mktemp -d)"
trap 'rm -rf "${TMPDIR}"' EXIT

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
    curl -fsSL https://opencode.ai/install | bash
else
    log "Opencode already installed"
fi

if ! command -v nvim &>/dev/null; then
    log "Installing Neovim stable..."
    wget -q "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz" -O "${TMPDIR}/nvim-linux-x86_64.tar.gz"
    tar -xzf "${TMPDIR}/nvim-linux-x86_64.tar.gz" -C "${TMPDIR}"

    rm -rf ~/.neovim
    mv "${TMPDIR}/nvim-linux-x86_64" ~/.neovim
else
    log "Neovim already installed"
fi

log "Devtools installed"
