#!/usr/bin/env bash

set -euo pipefail

log() { printf "\033[1;34minfo\033[0m %s\n" "$*"; }

log "running install-deps"
bash ./scripts/install-deps.sh

log "running install-configs"
bash ./scripts/install-configs.sh

log "running install-nerdfont"
bash ./scripts/install-nerdfont.sh

log "running install-post"
bash ./scripts/install-post.sh
