#/usr/bin/env bash

ESC="\033"
FG1="${ESC}[38;5;1m"
FG2="${ESC}[38;5;2m"
FG5="${ESC}[38;5;5m"
RES="${ESC}[0m"

set -e


printf "${FG5}installation starting!${RES}\n"

if ! grep -qi debian /etc/os-release >/dev/null 2>&1; then
    printf "${FG1}install cancelled: only debian supported${RES}\n"
    exit 1
fi

printf "${FG5}git${RES} ${FG2}[1/9]${RES}\n"
sudo apt-get -y install git

if [ ! -e $HOME/.gitconfig ]; then
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
sudo apt-get -y install zsh zsh-autosuggestions wget curl tmux vim man-db \
    less foot zip unzip fzf fastfetch btop jq ripgrep fd-find bat \
    ca-certificates

cp -r config/foot $HOME/.config
cp config/.tmux.conf $HOME
cp config/.vimrc $HOME
cp config/.zshrc $HOME
sudo chsh -s $(which zsh) $USER



printf "${FG5}devel${RES} ${FG2}[3/9]${RES}\n"
sudo apt-get -y install gcc make cmake golang luajit nodejs npm

if ! command -v uv >/dev/null 2>&1; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

if ! command -v rustup >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi



printf "${FG5}neovim${RES} ${FG2}[4/9]${RES}\n"
if ! command -v nvim >/dev/null 2>&1; then
    NVIM_VERSION="v0.11.3"

    mkdir -p $HOME/.local/bin

    wget https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/nvim-linux-x86_64.tar.gz
    tar -xzf nvim-linux-x86_64.tar.gz -C $HOME/.local
    ln -sf $HOME/.local/nvim-linux-x86_64/bin/nvim $HOME/.local/bin/nvim
    rm nvim-linux-x86_64.tar.gz

    cp -r config/nvim $HOME/.config

    $HOME/.cargo/bin/cargo install tree-sitter-cli
fi



printf "${FG5}docker${RES} ${FG2}[5/9]${RES}\n"
if ! command -v docker >/dev/null 2>&1; then
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
sudo apt-get -y install sway swaybg swaylock autotiling gammastep waybar \
    dunst tofi vlc thunar grimshot wl-clipboard brightnessctl \
    xdg-desktop-portal xdg-desktop-portal-wlr xwayland xwaylandvideobridge \
    dbus

cp -rv config/gammastep $HOME/.config
cp -rv config/waybar $HOME/.config
cp -rv config/dunst $HOME/.config
cp -rv config/sway $HOME/.config
cp -rv config/tofi $HOME/.config

mkdir -p $HOME/Pictures/walls
cp -v walls/* $HOME/Pictures/walls



printf "${FG5}hardware${RES} ${FG2}[7/9]${RES}\n"
sudo apt-get -y install playerctl pipewire pipewire-pulse wireplumber \
    bluetooth bluez thermald

if ! command -v intel-undervolt >/dev/null 2>&1; then
    mkdir -p $HOME/git
    git clone https://github.com/kitsunyan/intel-undervolt.git $HOME/git/intel-undervolt

    cd $HOME/git/intel-undervolt
    ./configure --enable-systemd --unitdir=/lib/systemd/system
    make
    sudo make install
    cd -

    sudo sed -i "s/^undervolt 0.*/undervolt 0 'CPU' -100/" /etc/intel-undervolt.conf
    sudo sed -i "s/^undervolt 1.*/undervolt 1 'GPU' -100/" /etc/intel-undervolt.conf
    sudo sed -i "s/^undervolt 2.*/undervolt 2 'GPU Cache' -100/" /etc/intel-undervolt.conf
fi

if ! command -v auto-cpufreq >/dev/null 2>&1; then
    mkdir -p $HOME/git
    git clone https://github.com/AdnanHodzic/auto-cpufreq.git $HOME/git/auto-cpufreq

    cd $HOME/git/auto-cpufreq
    sudo ./auto-cpufreq-installer
    suod auto-cpufreq --install
    cd -
fi

systemctl --user enable --now pipewire pipewire-pulse wireplumber
sudo systemctl enable --now bluetooth thermald intel-undervolt



printf "${FG5}fonts${RES} ${FG2}[8/9]${RES}\n"
sudo apt-get -y install fontconfig fonts-noto

mkdir -p $HOME/.local/share/fonts

if ! fc-list | grep -qi "JetBrainsMono Nerd Font"; then
    cd /tmp
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
    unzip JetBrainsMono.zip
    cp JetBrainsMonoNerdFont-Regular.ttf $HOME/.local/share/fonts
    fc-cache
    cd -
fi



printf "${FG5}apps${RES} ${FG2}[9/9]${RES}\n"
if ! command -v brave-browser >/dev/null 2>&1; then
    curl -fsS https://dl.brave.com/install.sh | sh
fi

if ! command -v discord >/dev/null 2>&1; then
    wget -O discord.deb 'https://discord.com/api/download?platform=linux&format=deb'
    sudo apt-get install -y ./discord.deb
    rm discord.deb
fi

printf "${FG2}installation complete!${RES}\n"
