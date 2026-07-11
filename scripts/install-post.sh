#!/usr/bin/env bash

set -euo pipefail

ok()   { printf "\033[1;32minfo\033[0m %s\n" "$*"; }
log()  { printf "\033[1;34minfo\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33mwarn\033[0m %s\n" "$*"; }

WALLPAPER=~/.cache/rice/walls/01-dude-light.jpg

if command -v matugen &>/dev/null; then
    log "generating colors"
    matugen image $WALLPAPER -m light --prefer saturation
    ok "colors generated"
else
    warn "skipping color generation, matugen not found"
fi

ok "post-install done"
