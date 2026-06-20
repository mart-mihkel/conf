#!/usr/bin/env bash

set -euo pipefail

log()  { printf "\033[1;34m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }
warn() { printf "\033[1;33m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }

WALLPAPER=~/.cache/rice/walls/light-moomin-fishing.png

if ! command -v hellwal &>/dev/null; then
    warn "Skipping color generation, hellwal not found"
else
    log "Generating colors"
    hellwal --image $WALLPAPER --light --skip-term-colors --quiet
fi

log "Post-install done"
