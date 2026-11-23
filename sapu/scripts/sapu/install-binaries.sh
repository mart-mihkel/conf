#!/usr/bin/env bash

set -euo pipefail

log()   { printf "\033[1;34minfo    \033[0m %s\n" "$*"; }
error() { printf "\033[1;31merror   \033[0m %s\n" "$*" >&2; }

SOURCE="${1:?Path to the uploaded binaries directory is required}"
DESTINATION="${HOME}/.local/bin"

if [[ ! -d "$SOURCE" ]]; then
    error "binaries directory not found: $SOURCE"
    exit 1
fi

found=0

for file in "$SOURCE"/*; do
    if [[ ! -f "$file" ]]; then
        continue
    fi

    if [[ "$found" == 0 ]]; then
        mkdir -p "$DESTINATION"
        found=1
    fi

    log "installing $(basename "$file") to $DESTINATION..."
    install -m 755 "$file" "$DESTINATION/$(basename "$file")"
done

if [[ "$found" == 0 ]]; then
    error "no binaries found in $SOURCE"
    exit 1
fi
