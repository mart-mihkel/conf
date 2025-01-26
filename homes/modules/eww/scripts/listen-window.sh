#!/bin/sh

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

# $2 -> class, $3 -> title
hyprctl activewindow -j | jq -r .class
socat -u UNIX-CONNECT:$SOCKET - | stdbuf -o0 awk -F '>>|,' '/^activewindow>>/{print $2}'
