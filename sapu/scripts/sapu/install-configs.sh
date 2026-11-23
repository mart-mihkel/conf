#!/usr/bin/env bash

set -euo pipefail

log()   { printf "\033[1;34minfo    \033[0m %s\n" "$*"; }
warn()  { printf "\033[1;33mwarning \033[0m %s\n" "$*"; }
error() { printf "\033[1;31merror   \033[0m %s\n" "$*" >&2; }

REPOSITORY="$(cd "$(dirname "$0")/../.." && pwd)"
CONFIGS="${REPOSITORY}/config"

install-file() {
    local source="$1"
    local destination="$2"
    local response

    if [[ ! -f "$source" ]]; then
        error "configuration file not found: $source"
        return 1
    fi

    if [[ -d "$destination" && ! -L "$destination" ]]; then
        error "destination is a directory: $destination"
        return 1
    fi

    if [[ -e "$destination" || -L "$destination" ]]; then
        if [[ -f "$destination" ]] && cmp -s "$source" "$destination"; then
            log "$destination already installed"
            return 0
        fi

        printf 'Overwrite %s? [y/N] ' "$destination"

        if ! read -r response || [[ ! "$response" =~ ^[Yy]$ ]]; then
            warn "keeping $destination"
            return 0
        fi

        rm -f "$destination"
    fi

    mkdir -p "$(dirname "$destination")"
    install -m 644 "$source" "$destination"
    log "installed $destination"
}

install-file "${CONFIGS}/.bashrc" "${HOME}/.bashrc"
install-file "${CONFIGS}/.vimrc" "${HOME}/.vimrc"
install-file "${CONFIGS}/tmux/tmux.conf" "${HOME}/.config/tmux/tmux.conf"
install-file "${CONFIGS}/direnv/direnvrc" "${HOME}/.config/direnv/direnvrc"
install-file "${CONFIGS}/git/config" "${HOME}/.config/git/config"
install-file "${CONFIGS}/git/ignore" "${HOME}/.config/git/ignore"
install-file "${CONFIGS}/tilix/schemes/sapu-light.json" "${HOME}/.config/tilix/schemes/sapu-light.json"
install-file "${CONFIGS}/tilix/schemes/sapu-dark.json" "${HOME}/.config/tilix/schemes/sapu-dark.json"
