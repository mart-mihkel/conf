#!/usr/bin/env bash

set -euo pipefail

log() { printf "\033[1;34m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }

WALLPAPER=~/.cache/rice/walls/light-moomin-fishing.png

log "Generating colors"
hellwal --image $WALLPAPER --light --skip-term-colors --quiet

log "Post-install done"
