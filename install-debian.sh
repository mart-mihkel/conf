#/usr/bin/env bash

ESC="\033"
FG0="${ESC}[38;5;0m"
FG1="${ESC}[38;5;1m"
FG2="${ESC}[38;5;2m"
FG3="${ESC}[38;5;3m"
FG4="${ESC}[38;5;4m"
FG5="${ESC}[38;5;5m"
FG6="${ESC}[38;5;6m"
FG7="${ESC}[38;5;7m"
RES="${ESC}[0m"

NSTEPS=10

set -e

catch_errors() {
  echo -e "${FG1}installation failed!${RES}"
}

trap catch_errors ERR


echo -e "${FG4}installation starting!${RES}"
echo -e "\n${FG5}git${RES} ${FG2}[1/${NSTEPS}]${RES}"
sudo apt-get -y install git

if [[ ! -e ~/.config/git/config ]]; then
    echo -n "git username: "; read GIT_NAME
    echo -n "git email: "; read GIT_EMAIL
    git config --global user.name $GIT_NAME
    git config --global user.email $GIT_EMAIL
    git config --global core.editor vim
    git config --global pull.rebase true
    git config --global init.defaultBranch main
    git config --global url."git@github.com:".insteadOf gh:
fi



echo -e "\nterminal ${FG2}[2/${NSTEPS}]${RES}"
sudo apt-get -y install zsh zsh-autosuggestions \
    wget curl tmux vim man-db less foot zip unzip \
    fzf fastfetch btop jq ripgrep fdfind batcat \
    ca-certificates

cp -rv config/foot ~/.config
cp -v config/.tmux.conf ~
cp -v config/.vimrc ~
cp -v config/.zshrc ~
sudo chsh -s /bin/zsh $USER
mkdir -p ~/.local/state/vim



echo -e "\nneovim ${FG2}[3/${NSTEPS}]${RES}"
NVIM_VERSION="v0.11.3"
rm -r ~/.local/nvim-linux-x86_64
wget https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/nvim-linux-x86_64.tar.gz
tar -xzvf nvim-linux-x86_64.tar.gz -C ~/.local
ln -s ~/.local/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim
cp -rv config/nvim ~/.config
rm -v nvim-linux-x86_64.tar.gz



echo -e "\ndevel ${FG2}[4/${NSTEPS}]${RES}"
sudo apt-get -y gcc make cmake golang \
    luajit nodejs npm

if ! command -v uv &>/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

if ! command -v cargo &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi



echo -e "\n${FG4}docker${RES} ${FG2}[5/${NSTEPS}]${RES}"

if ! command -v docker &>/dev/null; then
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

    sude usermod -aG docker $USER
fi


echo -e "\n${FG2}sway${RES} ${FG2}[6/${NSTEPS}]${RES}"
sudo apt-get -y install sway swaybg swaylock \
    autotiling waybar dunst tofi vlc thunar \
    gammastep grimshot wl-clipboard brightnessctl \
    dbus xwayland xwaylandvideobridge \
    xdg-desktop-portal xdg-desktop-portal-wlr

cp -rv config/waybar ~/.config
cp -rv config/dunst ~/.config
cp -rv config/sway ~/.config
cp -rv config/tofi ~/.config
mkdir -p ~/Pictures/walls
cp -v walls/* ~/Pictures/walls



echo -e "\naudio ${FG2}[7/${NSTEPS}]${RES}"
sudo apt-get -y install playerctl pipewire \
    pipewire-pulse wireplumber

systemctl --user enable --now pipewire pipewire-pulse wireplumber



echo -e "\n${FG4}bluetooth${RES} ${FG2}[7/${NSTEPS}]${RES}"
sudo apt-get -y install bluetooth bluez
sudo systemctl enable --now bluetooth



echo -e "\npower ${FG2}[8/${NSTEPS}]${RES}"
sudo apt-get -y tlp thermald
sudo sed -i 's/^#CPU_SCALING_GOVERNOR_ON_BAT=.*/CPU_SCALING_GOVERNOR_ON_BAT=powersave/' /etc/tlp.conf
sudo sed -i 's/^#START_CHARGE_THRESH_BAT0=.*/START_CHARGE_THRESH_BAT0=75/' /etc/tlp.conf
sudo sed -i 's/^#STOP_CHARGE_THRESH_BAT0=.*/STOP_CHARGE_THRESH_BAT0=80/' /etc/tlp.conf
sudo systemctl enable --now tlp thermald



echo -e "\nfonts ${FG2}[9/${NSTEPS}]${RES}"
sudo apt-get -y fontconfig fonts-noto
mkdir -p ~/.local/share/fonts

if ! fc-list | grep -qi "JetBrainsMono Nerd Font"; then
    cd /tmp
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
    unzip JetBrainsMono.zip
    cp JetBrainsMonoNerdFont-Regular.ttf ~/.local/share/fonts
    fc-cache
    cd -
fi



echo -e "\napps ${FG2}[10/${NSTEPS}]${RES}"
sudo apt-get install -y qbittorrent

if ! command -v brave-browser &>/dev/null; then
    curl -fsS https://dl.brave.com/install.sh | sh
fi

wget -O discord.deb 'https://discord.com/api/download?platform=linux&format=deb'
sudo apt-get install -y ./discord.deb
rm discord.deb

echo -e "\n${FG2}installation complete!${RES}"
