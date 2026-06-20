# Dotfiles

For debian unstable

## Dependencies

| Type         | Method                                          | Packages                                                                                  |
| ------------ | ----------------------------------------------- | ----------------------------------------------------------------------------------------- |
| **Desktop**  | `apt`                                           | `dunst foot hypridle hyprland hyprlock tofi waybar`                                       |
|              | build from source                               | [`awww`](https://codeberg.org/LGFae/awww) [`hellwal`](https://github.com/danihek/hellwal) |
| **Tools**    | `apt`                                           | `bluez brightnessctl btop gammastep playerctl wireplumber`                                |
|              | `cargo`                                         | `bluetui impala wayland-pipewire-idle-inhibit`                                            |
| **Devtools** | `apt`                                           | `batcat direnv fdfind git glow ripgrep tmux vim zsh zsh-autosuggestions`                  |
|              | [install script](./scripts/install-devtools.sh) | `cargo neovim opencode pnpm uv`                                                           |

## Install

Config files, fonts and some dependencies are installed with the script

```bash
./scripts/install.sh
```
