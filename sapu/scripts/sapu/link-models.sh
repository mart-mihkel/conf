#!/usr/bin/env bash

set -euo pipefail

log()   { printf "\033[1;34minfo    \033[0m %s\n" "$*"; }
error() { printf "\033[1;31merror   \033[0m %s\n" "$*" >&2; }

SOURCE="${1:?Path to the SAPU models directory is required}"
REPOSITORY="$(cd "$(dirname "$0")/../.." && pwd)"
DESTINATION="${2:-${REPOSITORY}/llama/models}"

if [[ ! -d "$SOURCE" ]]; then
    error "models directory not found: $SOURCE"
    exit 1
fi

mkdir -p "$DESTINATION"

SOURCE="$(cd "$SOURCE" && pwd -P)"
DESTINATION="$(cd "$DESTINATION" && pwd -P)"

if [[ "$DESTINATION/" == "$SOURCE/"* || "$SOURCE/" == "$DESTINATION/"* ]]; then
    error "source and destination must not contain one another"
    exit 1
fi

while IFS= read -r -d '' file; do
    target="${DESTINATION}/$(basename "$file")"

    if [[ -L "$target" && "$(readlink "$target")" == "$file" ]]; then
        continue
    fi

    if [[ -e "$target" || -L "$target" ]]; then
        error "destination already exists: $target"
        exit 1
    fi

    ln -s "$file" "$target"
    log "linked $target"
done < <(find "$SOURCE" -type f -name '*.gguf' -print0)
