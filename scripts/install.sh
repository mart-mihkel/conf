#!/usr/bin/env bash

set -euo pipefail

log() { printf "\033[1;34m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }

log "Running install-configs"
source ./scripts/install-configs.sh

log "Running install-nerdfont"
source ./scripts/install-nerdfont.sh

log "Running install-neovim"
source ./scripts/install-neovim.sh

log "Running install-post"
source ./scripts/install-post.sh
