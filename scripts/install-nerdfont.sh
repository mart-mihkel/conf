#!/usr/bin/env bash

set -euo pipefail

ok()   { printf "\033[1;32minfo\033[0m %s\n" "$*"; }
log()  { printf "\033[1;34minfo\033[0m %s\n" "$*"; }

FONTDIR="${HOME}/.local/share/fonts"
TMPDIR="$(mktemp -d)"
NERDFONT="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz" 

trap 'rm -rf "${TMPDIR}"' EXIT

if ! ls "${FONTDIR}"/JetBrainsMono*.ttf &>/dev/null 2>&1; then
    log "creating font directory..."
    mkdir -p "${FONTDIR}"

    log "downloading JetBrainsMono NerdFont..."
    wget -q $NERDFONT -O "${TMPDIR}/jetbrains-mono.tar.xz"

    log "extracting fonts..."
    tar -xf "${TMPDIR}/jetbrains-mono.tar.xz" -C "${FONTDIR}"

    log "updating font cache..."
    fc-cache -f

    ok "nerdfont installed"
else
    ok "nerdfont already installed"
fi
