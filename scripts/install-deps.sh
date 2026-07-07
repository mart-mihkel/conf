#!/usr/bin/env bash

set -euo pipefail

log()  { printf "\033[1;34m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }
warn() { printf "\033[1;33m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }

TMPDIR="$(mktemp -d)"
trap 'rm -rf "${TMPDIR}"' EXIT

PKGS_APT=(
    # hardware
    bluez
    brightnessctl
    pipewire
    wireplumber
    # windowmanager
    dunst
    foot
    hypridle
    hyprland
    hyprlock
    tofi
    waybar
    gammastep
    grim
    hyprpicker
    playerctl
    slurp
    wl-clipboard
    wtype
    # devtools
    bat
    btop
    curl
    direnv
    fd-find
    git
    glow
    jq
    ripgrep
    tmux
    vim
    wget
    zsh
    zsh-autosuggestions
)

# TODO: these require some dev libraries to build
PKGS_CARGO=(
    bluetui
    matugen
    typst-cli
    wlctl
    wayland-pipewire-idle-inhibit
)

NVIM_STABLE="https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz" 
GHOSTTY_DEB="https://github.com/dariogriffo/ghostty-debian/releases/download/1.3.1%2B3/ghostty_1.3.1-3%2Bsid_amd64.deb"
GRIMBLAST_PERMALINK="https://raw.githubusercontent.com/hyprwm/contrib/bf1a7cdb086587e6bed6e8ecd285a81c01a11c54/grimblast/grimblast" 
AWWW_REPO="https://codeberg.org/LGFae/awww.git"

log "installing apt packages..."
sudo apt update
sudo apt install -y "${PKGS_APT[@]}"

if ! command -v uv &>/dev/null; then
    log "installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    log "uv already installed"
fi

if ! command -v pnpm &>/dev/null; then
    log "installing pnpm..."
    curl -fsSL https://get.pnpm.io/install.sh | sh -
else
    log "pnpm already installed"
fi

if ! command -v opencode &>/dev/null; then
    log "installing opencode..."
    curl -fsSL https://opencode.ai/install | bash
else
    log "opencode already installed"
fi

if ! command -v nvim &>/dev/null; then
    log "installing Neovim stable..."

    wget -q $NVIM_STABLE -O "${TMPDIR}/nvim-linux-x86_64.tar.gz"
    tar -xzf "${TMPDIR}/nvim-linux-x86_64.tar.gz" -C "${TMPDIR}"

    rm -rf ~/.neovim
    mv "${TMPDIR}/nvim-linux-x86_64" ~/.neovim
else
    log "neovim already installed"
fi

if ! command -v grimblast &>/dev/null; then
    log "installing grimblast..."
    mkdir -p ~/.local/bin
    wget -q $GRIMBLAST_PERMALINK -O ~/.local/bin/grimblast

    chmod +x ~/.local/bin/grimblast
else
    log "grimblast already installed"
fi

if ! command -v ghostty &>/dev/null; then
    log "installing ghostty..."
    wget -q "$GHOSTTY_DEB" -O "${TMPDIR}/ghostty.deb"
    sudo dpkg -i "${TMPDIR}/ghostty.deb"
else
    log "ghostty already installed"
fi

if ! command -v cargo &>/dev/null; then
    log "installing cargo via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

    source ~/.cargo/env
else
    log "cargo already installed"
fi

log "installing cargo packages..."
cargo install --locked "${PKGS_CARGO[@]}"

if ! command -v awww &>/dev/null || ! command -v awww-daemon &>/dev/null; then
    log "building awww from source..."

    git clone $AWWW_REPO "${TMPDIR}/awww"
    cargo build --release --manifest-path "${TMPDIR}/awww/Cargo.toml"

    mkdir -p ~/.local/bin
    cp "${TMPDIR}/awww/target/release/awww" ~/.local/bin/
    cp "${TMPDIR}/awww/target/release/awww-daemon" ~/.local/bin/
else
    log "awww already installed"
fi

log "dependencies installed"
