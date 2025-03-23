#!/bin/bash

cfg="$HOME/.config"
cache="$HOME/.cache"
wals="$HOME/git/wallpapers"
pick="$wals/$(ls "$wals" | grep -E 'jpg|jpeg|png' | rofi -dmenu -p '󰥷 ')"

if [[ "$pick" == "$wals/" ]]; then
    echo "No wallpaper selected"
    exit 1
fi

cp -f $pick $cache/wallpaper
hyprctl hyprpaper reload ,$pick
