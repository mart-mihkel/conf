#!/usr/bin/env bash

set -euo pipefail

log()   { printf "\033[1;34minfo    \033[0m %s\n" "$*"; }
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DESTINATION="${ROOT}/build/tmux-bundle"
mkdir -p "$DESTINATION"
WORKDIR="$(mktemp -d "${ROOT}/build/.tmux-bundle.XXXXXXXX")"
trap 'rm -rf "$WORKDIR"' EXIT

log "building the Linux x86-64 tmux bundle..."
docker run --rm --platform linux/amd64 \
    -v "${WORKDIR}:/output" \
    -v "${ROOT}/scripts/local/build-tmux-bundle-container.sh:/build.sh:ro" \
    alpine:3.22 /bin/sh /build.sh

mv "$WORKDIR/tmux-bundle.tar.gz" "$DESTINATION/tmux-bundle.tar.gz"
(cd "$DESTINATION" && shasum -a 256 tmux-bundle.tar.gz > SHA256SUMS)
log "tmux bundle ready in $DESTINATION"
