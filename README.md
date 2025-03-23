# Conf🍚

**Hyprland rice** and minimal i3 config

![flowers](./.github/nord-flowers.png)

![flower](./.github/nord-flower.png)

![stars](./.github/nord-stars.png)

![sea](./.github/nord-sea.png)

![tray](./.github/tray.png)

## Install🤢

```bash
cp -r ~/.config ~/.config.bak # back up your configs
cp -r .config/* ~/.config     # copy the rice

echo 'ZDOTDIR=$HOME/.config/zsh' >> ~/.zshenv

# see below for dependencies
yay -S --needed hyprland hyprlock hypridle hyprpaper eww dunst kitty \
    rofi-emoji rofi-wayland zsh zsh-autosuggestions zsh-syntax-highlighting \
    tmux neovim ripgrep grim slurp jq socat wtype wl-clipboard playerctl \
    brightnessctl pipewire networkmanager noto-fonts-emoji \
    ttf-jetbrains-mono-nerd

# and extra dependencies
yay -S --needed i3 autotiling xdotool xclip alacritty ghostty maim btop \
    neofetch fastfetch cava pipes.sh tty-clock cowsay nmtui bluetui pulsemixer
```

### Keybinds🔑

See [hyprland.conf](./.config/hypr/hyprland.conf) for hyprland or
[config](./.config/i3/config) for i3.

### Wallpapers🖼️

Hyprpaper tries to load `~/.cache/wallpaper` on startup. The
[wallpaper script](./.config/hypr/scripts/wallpaper.sh) looks for files in
`~/git/wallpapers`, activates the selected and saves it to cache. The i3 setup
has no wallpaper.

### Dependencies📦

| package                 | description            |
| ----------------------- | ---------------------- |
| hyprland                | window manager         |
| hyprlock                | screen locker          |
| hypridle                | idle daemon            |
| hyprpaper               | wallpaper daemon       |
| eww                     | widgets (status bar)   |
| dunst                   | notification daemon    |
| kitty                   | terminal emulator      |
| rofi-emoji              | emoji picker           |
| rofi-wayland            | application launcher   |
| zsh                     | shell                  |
| zsh-autosuggestion      | zsh suggestions        |
| zsh-syntax-highlighting | zsh syntax highlight   |
| tmux                    | terminal multiplexer   |
| neovim                  | text editor            |
| ripgrep                 | grep (nvim telescope)  |
| grim                    | screenshot tool        |
| slurp                   | screen grab tool       |
| jq                      | json processor         |
| socat                   | socket cat             |
| wtype                   | wayland paste tool     |
| wl-clipboard            | wayland clipboard tool |
| playerctl               | audio player control   |
| brightnessctl           | backlight control      |
| pipewire                | audio control          |
| networkmanager          | networking             |
| noto-fonts-emoji        | emoji font             |
| ttf-jetbrains-mono-nerd | font and icons         |

### Extra dependencies✨

| package    | description             |
| ---------- | ----------------------- |
| i3         | x11 window manager      |
| autotiling | i3 automatic tiling     |
| xdotool    | x11 paste tool          |
| xclip      | x11 clipboard tool      |
| maim       | screenshot tool         |
| alacritty  | terminal emulator       |
| ghostty    | terminal emulator       |
| btop       | monitoring tool         |
| fastfetch  | system info fetcher     |
| neofetch   | system info fetcher     |
| cava       | audio screensaver       |
| pipes.sh   | pipes screensaver       |
| tty-clock  | clock screensaver       |
| cowsay     | cow sayer               |
| nmtui      | networkmanager frontend |
| bluetui    | bluetoothctl frontend   |
| pulsemixer | pipewire frontend       |
