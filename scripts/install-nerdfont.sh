#!/usr/bin/env bash

set -euo pipefail

log()  { printf "\033[1;34m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }

FONTDIR="${HOME}/.local/share/fonts"
TMPDIR="$(mktemp -d)"

trap 'rm -rf "${TMPDIR}"' EXIT

log "Creating font directory..."
mkdir -p "${FONTDIR}"

log "Downloading JetBrainsMono NerdFont..."
wget -q "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz" -O "${TMPDIR}/jetbrains-mono.tar.xz"

log "Extracting fonts..."
tar -xf "${TMPDIR}/jetbrains-mono.tar.xz" -C "${FONTDIR}"

log "Updating font cache..."
fc-cache -f

log "Nerdfont installed"
