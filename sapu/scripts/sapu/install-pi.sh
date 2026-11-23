#!/usr/bin/env bash

set -euo pipefail

log()   { printf "\033[1;34minfo    \033[0m %s\n" "$*"; }
error() { printf "\033[1;31merror   \033[0m %s\n" "$*" >&2; }

ARCHIVE="${1:?Path to the Pi Linux archive is required}"
INSTALL_ROOT="${HOME}/.local/opt"
DESTINATION="${INSTALL_ROOT}/pi"
BIN_DIR="${HOME}/.local/bin"
LINK="${BIN_DIR}/pi"
REPOSITORY="$(cd "$(dirname "$0")/../.." && pwd)"
CONFIG_SOURCE="${REPOSITORY}/pi/agent"
CONFIG_DESTINATION="${HOME}/.pi/agent"

if [[ ! -f "$ARCHIVE" ]]; then
    error "archive not found: $ARCHIVE"
    exit 1
fi

for file in auth.json AGENTS.md; do
    if [[ ! -f "$CONFIG_SOURCE/$file" ]]; then
        error "configuration file not found: $CONFIG_SOURCE/$file"
        exit 1
    fi
done

mkdir -p "$INSTALL_ROOT" "$BIN_DIR" "$CONFIG_DESTINATION"
WORKDIR="$(mktemp -d "${INSTALL_ROOT}/.pi-install.XXXXXXXX")"
trap 'rm -rf "${WORKDIR}"' EXIT

log "unpacking Pi..."
mkdir "${WORKDIR}/pi"
tar -xzf "$ARCHIVE" --strip-components=1 -C "${WORKDIR}/pi"

mv "${WORKDIR}/pi" "$DESTINATION"
ln -s "${DESTINATION}/pi" "$LINK"
install -m 600 "${CONFIG_SOURCE}/auth.json" "${CONFIG_DESTINATION}/auth.json"
install -m 644 "${CONFIG_SOURCE}/AGENTS.md" "${CONFIG_DESTINATION}/AGENTS.md"
log "installed Pi to $DESTINATION and linked $LINK"
log "installed Pi configuration to $CONFIG_DESTINATION"
