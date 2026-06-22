#!/usr/bin/env bash

set -euo pipefail

log()  { printf "\033[1;34m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }
warn() { printf "\033[1;33m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }

WALLPAPER=~/.cache/rice/walls/light-moomin-fishing.png

if command -v matugen &>/dev/null; then
    log "Generating colors"
    matugen image $WALLPAPER -m light --prefer saturation
else
    warn "Skipping color generation, matugen not found"
fi

log "Post-install done"
