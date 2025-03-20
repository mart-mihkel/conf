# Conf🍚

**Hyprland rice**

![flowers](./.github/nord-flowers.png)

![flower](./.github/nord-flower.png)

![stars](./.github/nord-stars.png)

![tray](./.github/tray.png)

## Install🤢

```bash
# back up your configs beforehand
cp -r ~/.config ~/.config.bak
cp ~/.bashrc ~/.bashrc.bak

# copy the rice
cp -r .config/* ~/.config
cp .bashrc ~/.bashrc

# see below for dependencies
yay -S --needed hyprland hyprlock hypridle hyprpaper eww dunst kitty rofi-emoji rofi-wayland tmux neovim ripgrep grim slurp socat wtype wl-clipboard playerctl brightnessctl pipewire networkmanager noto-fonts-emoji ttf-jetbrains-mono-nerd
```

### Keybinds🔑

See [hyprland.conf](./.config/hypr/hyprland.conf)

### Wallpapers🖼️

Hyprpaper tries to load `~/.cache/wallpaper` on startup. The
[wallpaper script](./.config/hypr/scripts/wallpaper.sh) looks for files in
`~/git/wallpapers`, activates the selected and saves it to cache.

### Extra✨

The [extra](https://github.com/mart-mihkel/conf/tree/extra) branch has configs
for *fastfetch*, *cava* and other such fancies.

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
| tmux                    | terminal multiplexer   |
| neovim                  | text editor            |
| ripgrep                 | grep (nvim telescope)  |
| grim                    | screenshot tool        |
| slurp                   | screen grab tool       |
| socat                   | socket cat             |
| wtype                   | wayland paste tool     |
| wl-clipboard            | wayland clipboard tool |
| playerctl               | audio player control   |
| brightnessctl           | backlight control      |
| pipewire                | audio control          |
| networkmanager          | networking             |
| noto-fonts-emoji        | emoji font             |
| ttf-jetbrains-mono-nerd | font and icons         |
