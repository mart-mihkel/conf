#/usr/bin/env bash

ESC="\033"
FG2="${ESC}[38;5;2m"
FG5="${ESC}[38;5;5m"
RES="${ESC}[0m"

set -e


printf "${FG5}installation starting!${RES}\n"
printf "${FG5}git${RES} ${FG2}[1/9]${RES}\n"
sudo apt-get -y install git

if [[ ! -e ~/.gitconfig ]]; then
    echo -n "git username: "; read GIT_NAME
    echo -n "git email: "; read GIT_EMAIL
    git config --global user.name $GIT_NAME
    git config --global user.email $GIT_EMAIL
    git config --global core.editor vim
    git config --global pull.rebase true
    git config --global init.defaultBranch main
    git config --global url."git@github.com:".insteadOf gh:
fi



printf "${FG5}terminal${RES} ${FG2}[2/9]${RES}\n"
sudo apt-get -y install zsh zsh-autosuggestions \
    wget curl tmux vim man-db less foot zip unzip \
    fzf fastfetch btop jq ripgrep fd-find bat \
    ca-certificates

cp -r config/foot ~/.config
cp config/.tmux.conf ~
cp config/.vimrc ~
cp config/.zshrc ~
sudo chsh -s /bin/zsh $USER



printf "${FG5}neovim${RES} ${FG2}[3/9]${RES}\n"
NVIM_VERSION="v0.11.3"
wget -q https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/nvim-linux-x86_64.tar.gz
tar -xzf nvim-linux-x86_64.tar.gz -C ~/.local
ln -sf ~/.local/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim
cp -r config/nvim ~/.config
rm nvim-linux-x86_64.tar.gz



printf "${FG5}devel${RES} ${FG2}[4/9]${RES}\n"
sudo apt-get -y install gcc make cmake golang \
    luajit nodejs npm

if [[ ! command -v uv &>/dev/null ]]; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

if [[ ! command -v rustup &>/dev/null ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi



printf "${FG5}docker${RES} ${FG2}[5/9]${RES}\n"
if [[ ! command -v docker &>/dev/null ]]; then
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli \
        containerd.io docker-buildx-plugin \
        docker-compose-plugin

    sudo usermod -aG docker $USER
fi


printf "${FG5}sway${RES} ${FG2}[6/9]${RES}\n"
sudo apt-get -y install sway swaybg swaylock \
    autotiling gammastep waybar dunst tofi vlc \
    thunar grimshot wl-clipboard brightnessctl \
    xdg-desktop-portal xdg-desktop-portal-wlr \
    xwayland xwaylandvideobridge dbus

cp -rv config/gammastep ~/.config
cp -rv config/waybar ~/.config
cp -rv config/dunst ~/.config
cp -rv config/sway ~/.config
cp -rv config/tofi ~/.config
mkdir -p ~/Pictures/walls
cp -v walls/* ~/Pictures/walls



printf "${FG5}hardware${RES} ${FG2}[7/9]${RES}\n"
sudo apt-get -y install playerctl pipewire \
    pipewire-pulse wireplumber bluetooth bluez \
    tlp thermald

sudo sed -i 's/^#CPU_SCALING_GOVERNOR_ON_BAT=.*/CPU_SCALING_GOVERNOR_ON_BAT=powersave/' /etc/tlp.conf
sudo sed -i 's/^#START_CHARGE_THRESH_BAT0=.*/START_CHARGE_THRESH_BAT0=75/' /etc/tlp.conf
sudo sed -i 's/^#STOP_CHARGE_THRESH_BAT0=.*/STOP_CHARGE_THRESH_BAT0=80/' /etc/tlp.conf
systemctl --user enable --now pipewire pipewire-pulse wireplumber
sudo systemctl enable --now bluetooth tlp thermald



printf "${FG5}fonts${RES} ${FG2}[8/9]${RES}\n"
sudo apt-get -y install fontconfig fonts-noto
mkdir -p ~/.local/share/fonts

if ! fc-list | grep -qi "JetBrainsMono Nerd Font"; then
    cd /tmp
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
    unzip JetBrainsMono.zip
    cp JetBrainsMonoNerdFont-Regular.ttf ~/.local/share/fonts
    fc-cache
    cd -
fi



printf "${FG5}apps${RES} ${FG2}[9/9]${RES}\n"
sudo apt-get install -y qbittorrent

if [[ ! command -v brave-browser &>/dev/null ]]; then
    curl -fsS https://dl.brave.com/install.sh | sh
fi

if [[ ! command -v discord &>/dev/null ]]; then
    wget -qO discord.deb 'https://discord.com/api/download?platform=linux&format=deb'
    sudo apt-get install -y ./discord.deb
    rm discord.deb
fi

printf "${FG2}installation complete!${RES}\n"
