#!/usr/bin/env bash

set -euo pipefail

log()   { printf "\033[1;34minfo    \033[0m %s\n" "$*"; }
error() { printf "\033[1;31merror   \033[0m %s\n" "$*" >&2; }

ALIAS="${1:?MinIO alias is required}"
PREFIX="${2:?MinIO prefix is required}"
TARGET="${ALIAS}/${PREFIX%/}/python/"

if [[ ! -f build/python/SHA256SUMS ]]; then
    error "missing Python archives; run just fetch-python first"
    exit 1
fi

(cd build/python && shasum -a 256 -c SHA256SUMS)

for file in build/python/*.tar.gz; do
    if [[ ! -f "$file" ]]; then
        error "missing Python archives; run just fetch-python first"
        exit 1
    fi

    name="$(basename "$file")"

    if ! (cd build/python && grep -Fxq "$(shasum -a 256 "./$name")" SHA256SUMS); then
        error "archive is not covered by SHA256SUMS: $name"
        exit 1
    fi
done

for file in build/python/*.tar.gz; do
    log "uploading $(basename "$file") to $TARGET..."
    mc cp "$file" "$TARGET"
done
