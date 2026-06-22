# Dotfiles

For Debian Sid

## Dependencies

| Type         | Method                                          | Packages                                                                                          |
| ------------ | ----------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| **Desktop**  | apt                                             | dunst foot hypridle hyprland hyprlock tofi waybar                                                 |
|              | build from source                               | [awww](https://codeberg.org/LGFae/awww)                                                           |
| **Tools**    | apt                                             | bluez brightnessctl btop gammastep grim hyprpicker playerctl slurp wireplumber wl-clipboard wtype |
|              | cargo                                           | bluetui impala matugen wayland-pipewire-idle-inhibit                                              |
|              | build from source                               | [grimblast](https://github.com/hyprwm/contrib/blob/main/grimblast/grimblast)                      |
| **Devtools** | apt                                             | batcat direnv fdfind git glow jq ripgrep tmux vim zsh zsh-autosuggestions                         |
|              | [install script](./scripts/install-devtools.sh) | cargo neovim opencode pnpm uv                                                                     |

## Install

Configs, fonts and some dependencies are installed with the script

```bash
./install.sh
```
