#!/usr/bin/env bash

set -euo pipefail

log()   { printf "\033[1;34minfo    \033[0m %s\n" "$*"; }
error() { printf "\033[1;31merror   \033[0m %s\n" "$*" >&2; }

ARCHIVE="${1:?Path to the ble.sh archive is required}"
DESTINATION="${HOME}/.local/share/blesh"

if [[ ! -f "$ARCHIVE" ]]; then
    error "ble.sh archive not found: $ARCHIVE"
    exit 1
fi

mkdir -p "$(dirname "$DESTINATION")"
TEMP_DESTINATION="$(mktemp -d "$(dirname "$DESTINATION")/.blesh.XXXXXXXX")"
trap 'rm -rf "$TEMP_DESTINATION"' EXIT

log "unpacking ble.sh..."
tar -xzf "$ARCHIVE" --strip-components=1 -C "$TEMP_DESTINATION"

if [[ ! -f "$TEMP_DESTINATION/ble.sh" || ! -d "$TEMP_DESTINATION/lib" || ! -d "$TEMP_DESTINATION/keymap" ]]; then
    error "ble.sh archive is missing runtime files"
    exit 1
fi

rm -rf -- "$DESTINATION"
mv -- "$TEMP_DESTINATION" "$DESTINATION"
log "installed ble.sh to $DESTINATION"
