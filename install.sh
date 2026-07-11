#!/usr/bin/env bash

set -euo pipefail

log() { printf "\033[1;34m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }

log "running install-deps"
bash ./scripts/install-deps.sh

log "running install-configs"
bash ./scripts/install-configs.sh

log "running install-nerdfont"
bash ./scripts/install-nerdfont.sh

log "running install-post"
bash ./scripts/install-post.sh
