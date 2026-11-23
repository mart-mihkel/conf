#!/usr/bin/env bash

set -euo pipefail

log()   { printf "\033[1;34minfo    \033[0m %s\n" "$*"; }
error() { printf "\033[1;31merror   \033[0m %s\n" "$*" >&2; }

ARCHIVE="${1:?Path to the tmux bundle archive is required}"
ROOT="$(cd "$(dirname "$0")" && pwd)"
DESTINATION="${HOME}/.local/share/sapu-shell"
BINDIR="${HOME}/.local/bin"

if [[ ! -f "$ARCHIVE" ]]; then
    error "tmux bundle not found: $ARCHIVE"
    exit 1
fi

if [[ -d "$BINDIR/tmux" && ! -L "$BINDIR/tmux" ]]; then
    error "$BINDIR/tmux is a directory"
    exit 1
fi

mkdir -p "$(dirname "$DESTINATION")" "$BINDIR"
TEMP_DESTINATION="$(mktemp -d "$(dirname "$DESTINATION")/.sapu-shell.XXXXXXXX")"
trap 'rm -rf "$TEMP_DESTINATION"' EXIT

log "unpacking and checking the tmux bundle..."
tar -xzf "$ARCHIVE" -C "$TEMP_DESTINATION"
"$TEMP_DESTINATION/lib/ld-musl-x86_64.so.1" --library-path "$TEMP_DESTINATION/lib" "$TEMP_DESTINATION/libexec/tmux" -V
test -f "$TEMP_DESTINATION/share/terminfo/t/tmux-256color"

rm -rf -- "$DESTINATION"
mv -- "$TEMP_DESTINATION" "$DESTINATION"

rm -f -- "$BINDIR/tmux"
install -m 755 "$ROOT/tmux-bundle.sh" "$BINDIR/tmux"

log "installed tmux to $BINDIR"
