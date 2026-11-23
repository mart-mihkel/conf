#!/usr/bin/env bash

set -euo pipefail

log()   { printf "\033[1;34minfo    \033[0m %s\n" "$*"; }
error() { printf "\033[1;31merror   \033[0m %s\n" "$*" >&2; }

ALIAS="${1:?MinIO alias is required}"
PREFIX="${2:?MinIO prefix is required}"
TARGET="${ALIAS}/${PREFIX%/}/bin/"
BINARIES=(uv uvx bat fd eza just direnv)

for binary in "${BINARIES[@]}"; do
    if [[ ! -f "build/bin/$binary" ]]; then
        error "missing build/bin/$binary; run just fetch-bin first"
        exit 1
    fi
done

for binary in "${BINARIES[@]}"; do
    log "uploading $binary to $TARGET..."
    mc cp "build/bin/$binary" "$TARGET"
done
