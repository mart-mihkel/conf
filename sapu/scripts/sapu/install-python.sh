#!/usr/bin/env bash

set -euo pipefail

log()   { printf "\033[1;34minfo    \033[0m %s\n" "$*"; }
error() { printf "\033[1;31merror   \033[0m %s\n" "$*" >&2; }

SOURCE="${1:?Path to downloaded Python archives is required}"

SOURCE="$(cd "$SOURCE" && pwd -P)"
DESTINATION="$(uv python dir)"

if [[ -f "$SOURCE/SHA256SUMS" ]]; then
    (cd "$SOURCE" && shasum -a 256 -c SHA256SUMS)
else
    log "no SHA256SUMS found; Python archives cannot be verified"
fi

mkdir -p "$DESTINATION"
TEMP_DESTINATION="$(mktemp -d "$DESTINATION/.install-python.XXXXXXXX")"
trap 'rm -rf "$TEMP_DESTINATION"' EXIT

for archive in "$SOURCE"/*.tar.gz; do
    if [[ ! -f "$archive" ]]; then
        error "no Python archives found in $SOURCE"
        exit 1
    fi

    name="$(basename "$archive" .tar.gz)"

    if [[ -z "$name" || "$name" == . || "$name" == .. ]]; then
        error "invalid archive name: $archive"
        exit 1
    fi

    log "installing $name..."
    mkdir "$TEMP_DESTINATION/$name"
    tar -xzf "$archive" --strip-components=1 -C "$TEMP_DESTINATION/$name"
    rm -rf -- "${DESTINATION:?}/${name:?}"
    mv -- "$TEMP_DESTINATION/$name" "$DESTINATION/$name"
done

log "Python installations are in $DESTINATION"
