#!/usr/bin/env bash

set -euo pipefail

log()   { printf "\033[1;34minfo    \033[0m %s\n" "$*"; }
warn()  {
    if [[ "$1" == "-n" ]]; then
        shift
        printf "\033[1;33mwarning \033[0m %s" "$*"
    else
        printf "\033[1;33mwarning \033[0m %s\n" "$*"
    fi
}
error() { printf "\033[1;31merror   \033[0m %s\n" "$*"; }

confirm-overwrite() {
    local src="$1"
    local dest="$2"

    if [ ! -e "$dest" ]; then
        return 0
    fi

    if diff -q "$src" "$dest" &>/dev/null; then
        log "$src already installed"
        return 1
    fi

    warn -n "$(basename "$dest") differs from $src, overwrite? [y/N] "
    read -r </dev/tty

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

install-file() {
    local src="$1"
    local dest="$2"

    local parent
    parent="$(dirname "$dest")"

    sudo mkdir -p "$parent"

    if confirm-overwrite "$src" "$dest"; then
        sudo cp "$src" "$dest"
        log "installed $dest"
    fi
}

install-dir() {
    local src="$1"
    local dest="$2"
    local file
    local path

    mkdir -p "$dest"

    while IFS= read -r -d '' file; do
        path="${file#"$src"/}"
        install-file "$file" "$dest/$path"
    done < <(find "$src" -type f -print0)
}

log "copying grub configs..."
install-dir ./boot /boot

GRUB_DEFAULTS=/etc/default/grub
GRUB_THEME=/boot/grub/themes/rice/theme.txt

if ! sudo test -f "$GRUB_DEFAULTS"; then
    error "$GRUB_DEFAULTS does not exist"
    error "exiting with error"
    exit 1
fi

log "setting grub theme..."
if sudo grep -q '^GRUB_THEME=' "$GRUB_DEFAULTS"; then
    sudo sed -i "s|^GRUB_THEME=.*|GRUB_THEME=\"$GRUB_THEME\"|" "$GRUB_DEFAULTS"
else
    printf 'GRUB_THEME="%s"\n' "$GRUB_THEME" | sudo tee -a "$GRUB_DEFAULTS" > /dev/null
fi

log "updating grub..."
sudo update-grub

log "grub configs installed"
