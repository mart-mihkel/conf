# Dotfiles

For debian unstable

## Dependencies

### Desktop

| Package    | Method                                       |
| ---------- | -------------------------------------------- |
| `hyprland` | `apt`                                        |
| `hyprlock` | `apt`                                        |
| `hypridle` | `apt`                                        |
| `waybar`   | `apt`                                        |
| `dunst`    | `apt`                                        |
| `foot`     | `apt`                                        |
| `tofi`     | `apt`                                        |
| `hellwal`  | [source](https://github.com/danihek/hellwal) |
| `awww`     | [source](https://codeberg.org/LGFae/awww)    |

### Tools

| Tool                            | Method  |
| ------------------------------- | ------- |
| `wayland-pipewire-idle-inhibit` | `cargo` |
| `brightnessctl`                 | `apt`   |
| `wireplumber`                   | `apt`   |
| `playerctl`                     | `apt`   |
| `gammastep`                     | `apt`   |
| `bluez`                         | `apt`   |

### Devtools

| Devtool               | Method                                  |
| --------------------- | --------------------------------------- |
| `zsh-autosuggestions` | `apt`                                   |
| `batcat`              | `apt`                                   |
| `fdfind`              | `apt`                                   |
| `direnv`              | `apt`                                   |
| `glow`                | `apt`                                   |
| `tmux`                | `apt`                                   |
| `zsh`                 | `apt`                                   |
| `vim`                 | `apt`                                   |
| `git`                 | `apt`                                   |
| `opencode`            | [script](./scripts/install-devtools.sh) |
| `neovim`              | [script](./scripts/install-neovim.sh)   |
| `cargo`               | [script](./scripts/install-devtools.sh) |
| `pnpm`                | [script](./scripts/install-devtools.sh) |
| `uv`                  | [script](./scripts/install-devtools.sh) |

## Install

Config files, fonts and some dependencies are installed with the script

```bash
./scripts/install.sh
```
