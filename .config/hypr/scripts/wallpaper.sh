#!/bin/bash

cfg="${HOME}/.config"
cache="${HOME}/.cache"
wals="${HOME}/git/wallpapers"
pick="${wals}/$(ls "$wals" | rofi -dmenu -p '󰥷 ')"

if [[ "$pick" == "$wals/" ]]; then
    echo "No wallpaper selected"
    exit 1
fi

cp -f $pick $cache/wallpaper

hyprctl hyprpaper unload all
hyprctl hyprpaper preload $pick
hyprctl hyprpaper wallpaper ", ${pick}"
