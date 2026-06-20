#!/usr/bin/env bash

set -euo pipefail

log() { printf "\033[1;34m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }

TMPDIR="$(mktemp -d)"
trap 'rm -rf "${TMPDIR}"' EXIT

log "Downloading Neovim stable..."
wget -q "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz" -O "${TMPDIR}/nvim-linux-x86_64.tar.gz"

log "Extracting..."
tar -xzf "${TMPDIR}/nvim-linux-x86_64.tar.gz" -C "${TMPDIR}"

log "Installing to ~/.nvim..."
rm -rf ~/.nvim
mv "${TMPDIR}/nvim-linux-x86_64" ~/.nvim

log "Neovim installed"
