#!/usr/bin/env bash

set -euo pipefail

log()   { printf "\033[1;34m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }
error() { printf "\033[1;31m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }

REMOTE=

if [ -z "$REMOTE" ]; then
    error "remote host is unset"
    error "exiting with error"
    exit 1
fi

TARGETS=(~/Documents ~/Pictures)
TARBALL="backup-$(date +"%Y-%m-%d").tar.gz"
TMPDIR="$(mktemp -d)"

trap 'rm -rf "${TMPDIR}"' EXIT

log "compressing..."
tar -Pczf "${TMPDIR}/${TARBALL}" \
    --exclude 'node_modules' \
    --exclude '.venv' \
    "${TARGETS[@]}"

log "uploading tarball to $REMOTE"
scp "${TMPDIR}/${TARBALL}" "${REMOTE}"

log "deleting tarball"
