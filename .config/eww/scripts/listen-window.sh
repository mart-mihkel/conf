#!/bin/sh

socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
socat -u UNIX-CONNECT:$socket - | stdbuf -o0 awk -F '>>|,' '/^activewindow>>/{print $2}' | while read class; do
    case $class in
        chromium) echo "󰖟" ;;
        Spotify) echo "󰓇" ;;
        discord) echo "" ;;
        kitty) echo "" ;;
        Slack) echo "" ;;
        steam) echo "󰓓" ;;
        vlc) echo "󰕼" ;;
        *) echo "" ;;
    esac
done
