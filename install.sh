#!/usr/bin/env bash

set -euo pipefail

log() { printf "\033[1;34m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }

log "running install-deps"
source ./scripts/install-deps.sh

log "running install-configs"
source ./scripts/install-configs.sh

log "running install-nerdfont"
source ./scripts/install-nerdfont.sh

log "running install-post"
source ./scripts/install-post.sh
