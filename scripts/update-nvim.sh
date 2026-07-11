#!/usr/bin/env bash

set -euo pipefail

ok()  { printf "\033[1;32minfo\033[0m %s\n" "$*"; }
log() { printf "\033[1;34minfo\033[0m %s\n" "$*"; }

TMPDIR="$(mktemp -d)"
trap 'rm -rf "${TMPDIR}"' EXIT

NVIM_STABLE="https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz" 

log "downloading neovim stable..."
wget -q $NVIM_STABLE -O "${TMPDIR}/nvim-linux-x86_64.tar.gz"

log "unpacking..."
tar -xzf "${TMPDIR}/nvim-linux-x86_64.tar.gz" -C "${TMPDIR}"

log "installing..."
rm -rf ~/.neovim
mv "${TMPDIR}/nvim-linux-x86_64" ~/.neovim

ok "neovim iupdated"
