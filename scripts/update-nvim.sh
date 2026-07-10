#!/usr/bin/env bash

set -euo pipefail

log()  { printf "\033[1;34m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }
warn() { printf "\033[1;33m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }

TMPDIR="$(mktemp -d)"
trap 'rm -rf "${TMPDIR}"' EXIT

NVIM_STABLE="https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz" 

log "installing Neovim stable..."

wget -q $NVIM_STABLE -O "${TMPDIR}/nvim-linux-x86_64.tar.gz"
tar -xzf "${TMPDIR}/nvim-linux-x86_64.tar.gz" -C "${TMPDIR}"

rm -rf ~/.neovim
mv "${TMPDIR}/nvim-linux-x86_64" ~/.neovim
