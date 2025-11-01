#/usr/bin/env bash

ESC="\033"
FG1="${ESC}[38;5;1m"
FG2="${ESC}[38;5;2m"
FG5="${ESC}[38;5;5m"
RES="${ESC}[0m"

BIN=$HOME/.local/bin
PIC=$HOME/Pictures
CFG=$HOME/.config
GIT=$HOME/git

set -e

if ! grep -qi debian /etc/os-release > /dev/null 2>&1; then
    printf "${FG1}install cancelled${RES}: only debian supported, use -f to force\n"
    exit 1
fi

printf "${FG2}install starting!${RES}\n"

printf "${FG2}installing${RES}: devel\n"
sudo apt-get -y install git zsh zsh-autosuggestions wget curl tmux vim man-db \
    zip unzip jq ripgrep fd-find ca-certificates gcc make cmake luajit nodejs \
    golang npm glow btop fzf direnv python3 python3-venv

sudo chsh -s $(which zsh) $USER
mkdir -p $BIN $PIC $CFG $GIT
cp -r scripts/* $BIN
cp -r config/* $CFG
cp -r walls $PIC
cp .zshrc $HOME

printf "${FG2}installing${RES}: windomanager\n"
sudo apt-get install -y sway swaybg swaylock swayidle autotiling gammastep \
    foot tofi vlc grimshot wtype wl-clipboard brightnessctl pcscd dbus \
    xdg-desktop-portal xdg-desktop-portal-wlr xwayland xwaylandvideobridge \
    playerctl pipewire pipewire-pulse pipewire-audio wireplumber bluetooth \
    network-manager bluez thermald zram-tools fontconfig fonts-noto \
    fonts-jetbrains-mono

systemctl --user enable --now pipewire pipewire-pulse wireplumber
sudo systemctl enable --now NetworkManager bluetooth thermald zramswap

if [ ! -e $HOME/.gitconfig ]; then
    printf "${FG2}configuring${RES}: git\n"
    echo -n "git name: "; read GIT_NAME
    echo -n "git email: "; read GIT_EMAIL
    git config --global user.name $GIT_NAME
    git config --global user.email $GIT_EMAIL
    git config --global core.editor vim
    git config --global pull.rebase true
else
    printf "${FG1}skipping${RES}: git, already configured\n"
fi

if ! command -v nvim > /dev/null 2>&1; then
    printf "${FG2}installing${RES}: neovim\n"
    sudo apt-get -y install python3-pynvim
    wget -q "https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz"
    tar -xzf nvim-linux-x86_64.tar.gz -C $HOME/.local
    ln -sf $HOME/.local/nvim-linux-x86_64/bin/nvim $BIN/nvim
    rm nvim-linux-x86_64.tar.gz
else
    printf "${FG1}skipping${RES}: neovim, already installed\n"
fi

if ! command -v docker > /dev/null 2>&1; then
    printf "${FG2}installing${RES}: docker\n"
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker $USER
else
    printf "${FG1}skipping${RES}: docker, already installed\n"
fi

if ! command -v cloudflared > /dev/null 2>&1; then
    printf "${FG2}installing${RES}: cloudflared\n"
    sudo mkdir -p --mode=0755 /usr/share/keyrings
    curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main" | sudo tee /etc/apt/sources.list.d/cloudflared.list
    sudo apt-get update
    sudo apt-get install -y cloudflared
else
    printf "${FG1}skipping${RES}: cloudflared, already installed\n"
fi

if ! command -v intel-undervolt > /dev/null 2>&1; then
    printf "${FG2}installing${RES}: intel-undervolt\n"
    pushd $GIT
    git clone https://github.com/kitsunyan/intel-undervolt.git
    pushd intel-undervolt
    ./configure --enable-systemd --unitdir=/lib/systemd/system
    make
    sudo make install
    popd
    popd

    sudo sed -i "s|^undervolt 0.*|undervolt 0 'CPU' -100|" /etc/intel-undervolt.conf
    sudo sed -i "s|^undervolt 1.*|undervolt 1 'GPU' -100|" /etc/intel-undervolt.conf
    sudo sed -i "s|^undervolt 2.*|undervolt 2 'GPU Cache' -100|" /etc/intel-undervolt.conf
    sudo systemctl enable --now intel-undervolt 
else
    printf "${FG1}skipping${RES}: intel-undervolt, already installed\n"
fi

if ! command -v auto-cpufreq > /dev/null 2>&1; then
    printf "${FG2}installing${RES}: auto-cpufreq\n"
    pushd $GIT
    git clone https://github.com/AdnanHodzic/auto-cpufreq.git $GIT/auto-cpufreq
    pushd auto-cpufreq
    sudo ./auto-cpufreq-installer
    sudo auto-cpufreq --install
    popd
    popd
else
    printf "${FG1}skipping${RES}: auto-cpufreq, already installed\n"
fi

if ! command -v qdigidoc4 > /dev/null 2>&1; then
    printf "${FG2}installing${RES}: qdigidoc4\n"
    pushd $GIT
    git clone https://github.com/open-eid/linux-installer.git
    pushd linux-installer
    ./install-open-eid.sh
    popd
    popd
else
    printf "${FG1}skipping${RES}: qdigidoc4, already installed\n"
fi

if ! command -v brave-browser > /dev/null 2>&1; then
    printf "${FG2}installing${RES}: brave-browser\n"
    curl -fsS https://dl.brave.com/install.sh | sh
else
    printf "${FG1}skipping${RES}: brave-browser, already installed\n"
fi

if ! command -v discord > /dev/null 2>&1; then
    printf "${FG2}installing${RES}: discord\n"
    wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
    sudo apt-get install -y ./discord.deb
    rm discord.deb
else
    printf "${FG1}skipping${RES}: discord, already installed\n"
fi

printf "${FG2}install finished!${RES}\n"
