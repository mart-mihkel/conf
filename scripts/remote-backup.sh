#!/usr/bin/env bash

log() { printf "\033[1;34m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }

REMOTE=<remote-host>
TARGETS=(~/Documents ~/Pictures)
TARBALL="backup-$(date +"%Y-%m-%d").tar.gz"

trap 'rm -rf "${TARBALL}"' EXIT

log "Compressing ${TARGETS[@]}"
tar -Pczf $TARBALL --exclude '.venv' --exclude 'node_modules' ${TARGETS[@]}

log "Uploading tarball to $REMOTE"
scp $TARBALL $REMOTE

log "Deleting tarball"
