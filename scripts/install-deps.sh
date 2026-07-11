#!/usr/bin/env bash

set -euo pipefail

ok()   { printf "\033[1;32minfo\033[0m %s\n" "$*"; }
log()  { printf "\033[1;34minfo\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33mwarn\033[0m %s\n" "$*"; }

TMPDIR="$(mktemp -d)"
trap 'rm -rf "${TMPDIR}"' EXIT

PKGS_APT=(
    # hardware
    bluez
    brightnessctl
    network-manager
    pipewire
    wireplumber

    # windowmanager
    dunst
    foot
    fonts-noto
    hypridle
    hyprland
    hyprlock
    hyprpicker
    hyprland-guiutils
    tofi
    rofi
    waybar
    gammastep
    grim
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
    ffmpeg
    fzf
    gcc
    git
    glow
    imagemagick
    jq
    make
    shellcheck
    openssl
    pkg-config
    ripgrep
    tmux
    vim
    wget
    zsh
    zsh-autosuggestions

    # libs
    liblz4-dev
    libssl-dev
    libclang-dev
    libdbus-1-dev
    libwayland-dev
    libpipewire-0.3-dev
)

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

log "enabling audio services"
systemctl --user enable --now pipewire
systemctl --user enable --now wireplumber
systemctl --user enable --now pipewire-pulse

if ! command -v uv &>/dev/null; then
    log "installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    ok "uv installed"
else
    ok "uv already installed"
fi

if ! command -v pnpm &>/dev/null; then
    log "installing pnpm..."
    curl -fsSL https://get.pnpm.io/install.sh | sh -
    ok "pnpm installed"
else
    ok "pnpm already installed"
fi

if ! command -v opencode &>/dev/null; then
    log "installing opencode..."
    curl -fsSL https://opencode.ai/install | bash
    ok "opencode installed"
else
    ok "opencode already installed"
fi

if ! command -v nvim &>/dev/null; then
    log "installing neovim stable..."

    wget -q $NVIM_STABLE -O "${TMPDIR}/nvim-linux-x86_64.tar.gz"
    tar -xzf "${TMPDIR}/nvim-linux-x86_64.tar.gz" -C "${TMPDIR}"

    rm -rf ~/.neovim
    mv "${TMPDIR}/nvim-linux-x86_64" ~/.neovim

    ok "neovim installed"
else
    ok "neovim already installed"
fi

if ! command -v grimblast &>/dev/null; then
    log "installing grimblast..."
    mkdir -p ~/.local/bin
    wget -q $GRIMBLAST_PERMALINK -O ~/.local/bin/grimblast

    chmod +x ~/.local/bin/grimblast
    ok "grimblast installed"
else
    ok "grimblast already installed"
fi

if ! command -v ghostty &>/dev/null; then
    log "installing ghostty..."
    wget -q "$GHOSTTY_DEB" -O "${TMPDIR}/ghostty.deb"
    sudo dpkg -i "${TMPDIR}/ghostty.deb"
    ok "ghostty installed"
else
    ok "ghostty already installed"
fi

if ! command -v cargo &>/dev/null; then
    log "installing cargo via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

    # shellcheck disable=1090
    source ~/.cargo/env

    ok "cargo installed"
else
    ok "cargo already installed"
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

    ok "awww installed"
else
    ok "awww already installed"
fi

ok "dependencies installed"
