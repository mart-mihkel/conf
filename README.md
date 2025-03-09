# Conf🍚

**i3 rice**

![tux](./.github/img/tux.png)

## Install🤢

```bash
# back up your configs beforehand
cp -r .config/* ~/.config
cp .tmux.conf ~/.tmux.conf
cp .xinitrc ~/.xinitrc
cp .bashrc ~/.bashrc

# see below for dependencies
yay -S i3 i3blocks dunst ghostty rofi rofi-emoji fzf bash tmux neovim nmtui bluetui pulsemixer maim xclip xdotool playerctl brightnessctl networkmanager noto-fonts-emoji ttf-jetbrains-mono-nerd
```

For wallpaper to work you should change `~/Pictures/wallpapers/tux.png` to your wallpaper in [i3 config](./.config/i3/config)

## Dependencies📦

| package                 | description             | required |
| ----------------------- | ----------------------- | -------- |
| i3                      | window manager          | ✔        |
| i3blocks                | status bar              | ✔        |
| dunst                   | notification daemon     | ✔        |
| ghostty                 | terminal emulator       | ✔        |
| rofi                    | application launcher    | ✔        |
| rofi-emoji              | emoji picker            |          |
| fzf                     | fuzzy finder            |          |
| bash                    | shell                   |          |
| tmux                    | terminal multiplexer    |          |
| neovim                  | text editor             |          |
| nmtui                   | networkmanager frontend |          |
| bluetui                 | bluetooth frontend      |          |
| pulsemixer              | audio control frontend  |          |
| maim                    | screenshot tool         |          |
| xclip                   | x11 clipboard tool      |          |
| xdotool                 | x11 paste tool          |          |
| playerctl               | audio player control    | ✔        |
| brightnessctl           | backlight control       | ✔        |
| networkmanager          | networking              | ✔        |
| noto-fonts-emoji        | emoji font              |          |
| ttf-jetbrains-mono-nerd | font and icons          | ✔        |
