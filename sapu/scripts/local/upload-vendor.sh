#!/usr/bin/env bash

set -euo pipefail

log()   { printf "\033[1;34minfo    \033[0m %s\n" "$*"; }
error() { printf "\033[1;31merror   \033[0m %s\n" "$*" >&2; }

ALIAS="${1:?MinIO alias is required}"
PREFIX="${2:?MinIO prefix is required}"
TARGET="${ALIAS}/${PREFIX%/}/vendor/"
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
WORKDIR="$(mktemp -d)"

trap 'rm -rf "${WORKDIR}"' EXIT
FILES=(pi-linux-x64.tar.gz llama.cpp.tar.gz ble.tar.gz)

for file in "${FILES[@]}"; do
    if [[ ! -f "build/vendor/$file" ]]; then
        error "missing build/vendor/$file; run just fetch-vendor first"
        exit 1
    fi
done

if [[ ! -f build/vendor/versions.txt || ! -f build/vendor/SHA256SUMS ]]; then
    error "missing vendor metadata; run just fetch-vendor first"
    exit 1
fi

(cd build/vendor && shasum -a 256 -c SHA256SUMS)

if [[ -f build/tmux-bundle/tmux-bundle.tar.gz ]]; then
    if [[ ! -f build/tmux-bundle/SHA256SUMS ]]; then
        error "missing tmux bundle checksum; run just fetch-vendor first"
        exit 1
    fi

    (cd build/tmux-bundle && shasum -a 256 -c SHA256SUMS)
fi

log "packaging the configuration repository..."
COPYFILE_DISABLE=1 tar --no-xattrs -czf "${WORKDIR}/sapu-config.tar.gz" \
    --exclude='.git' \
    --exclude='.env' \
    --exclude='build' \
    -C "$(dirname "$ROOT")" sapu

for file in "${FILES[@]}"; do
    log "uploading $file to $TARGET..."
    mc cp "build/vendor/$file" "$TARGET"
done

if [[ -f build/tmux-bundle/tmux-bundle.tar.gz ]]; then
    log "uploading tmux-bundle.tar.gz to $TARGET..."
    mc cp build/tmux-bundle/tmux-bundle.tar.gz "$TARGET"
else
    log "no tmux bundle found; run just fetch-vendor to include it"
fi

log "uploading sapu-config.tar.gz to $TARGET..."
mc cp "${WORKDIR}/sapu-config.tar.gz" "$TARGET"
