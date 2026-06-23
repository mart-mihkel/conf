#!/usr/bin/env bash

set -euo pipefail

log()  { printf "\033[1;34m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }
warn() { printf "\033[1;33m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }

TMPDIR="$(mktemp -d)"
trap 'rm -rf "${TMPDIR}"' EXIT

DESKTOP_APT=(dunst foot hypridle hyprland hyprlock tofi waybar bluez brightnessctl gammastep grim hyprpicker playerctl slurp wireplumber wl-clipboard wtype)
DEVTOOLS_APT=(bat btop curl direnv fd-find git glow jq ripgrep tmux vim wget zsh zsh-autosuggestions)

log "Installing APT packages..."
sudo apt update
sudo apt install -y "${DESKTOP_APT[@]}" "${DEVTOOLS_APT[@]}"

if ! command -v uv &>/dev/null; then
    log "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    log "Astral-uv already installed"
fi

if ! command -v pnpm &>/dev/null; then
    log "Installing pnpm..."
    curl -fsSL https://get.pnpm.io/install.sh | sh -
else
    log "Pnpm already installed"
fi

if ! command -v opencode &>/dev/null; then
    log "Installing opencode..."
    curl -fsSL https://opencode.ai/install | bash
else
    log "Opencode already installed"
fi

if ! command -v nvim &>/dev/null; then
    log "Installing Neovim stable..."
    wget -q "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz" -O "${TMPDIR}/nvim-linux-x86_64.tar.gz"
    tar -xzf "${TMPDIR}/nvim-linux-x86_64.tar.gz" -C "${TMPDIR}"

    rm -rf ~/.neovim
    mv "${TMPDIR}/nvim-linux-x86_64" ~/.neovim
else
    log "Neovim already installed"
fi

if ! command -v grimblast &>/dev/null; then
    log "Installing grimblast..."
    mkdir -p ~/.local/bin
    wget -q "https://raw.githubusercontent.com/hyprwm/contrib/bf1a7cdb086587e6bed6e8ecd285a81c01a11c54/grimblast/grimblast" -O ~/.local/bin/grimblast
    chmod +x ~/.local/bin/grimblast
else
    log "Grimblast already installed"
fi

if ! command -v cargo &>/dev/null; then
    log "Installing cargo via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
    log "Cargo already installed"
fi

log "Installing cargo tools..."
cargo install bluetui impala matugen wayland-pipewire-idle-inhibit

if ! command -v awww &>/dev/null || ! command -v awww-daemon &>/dev/null; then
    log "Building awww from source..."
    git clone https://codeberg.org/LGFae/awww.git "${TMPDIR}/awww"
    cargo build --release --manifest-path "${TMPDIR}/awww/Cargo.toml"
    mkdir -p ~/.local/bin
    cp "${TMPDIR}/awww/target/release/awww" ~/.local/bin/
    cp "${TMPDIR}/awww/target/release/awww-daemon" ~/.local/bin/
else
    log "awww already installed"
fi

log "Dependencies installed"
