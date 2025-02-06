#!/bin/sh

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
socat -u UNIX-CONNECT:$SOCKET - |
    stdbuf -o0 awk -F '>>|,' '/^activewindow>>/{print "\{\"class\":\"" $2 "\",\"title\":\"" $3 "\"\}"}' 2>/dev/null
