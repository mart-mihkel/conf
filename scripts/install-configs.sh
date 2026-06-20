#!/usr/bin/env bash

set -euo pipefail

log()  { printf "\033[1;34m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }

log "Creating directories..."
mkdir -p ~/.cache/hellwal
mkdir -p ~/.cache/rice
mkdir -p ~/.local/bin
mkdir -p ~/.config

log "Copying configs..."
cp -r ./config/* ~/.config

log "Copying scripts..."
cp ./bin/* ~/.local/bin

log "Copying wallpapers..."
cp -r ./assets/walls ~/.cache/rice

log "Copying assets..."
cp ./assets/emoji ~/.cache/rice

log "Configs installed"
