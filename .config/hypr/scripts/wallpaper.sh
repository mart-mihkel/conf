#!/bin/bash

CFG="${HOME}/.config"
CACHE="${HOME}/.cache"
WALLPAPERS="${HOME}/git/wallpapers"
PICK="${WALLPAPERS}/$(ls "$WALLPAPERS" | rofi -dmenu -p '󰥷 ')"

if [[ "$PICK" == "$WALLPAPERS/" ]]; then
    echo "No wallpaper selected"
    exit 1
fi

cp -f $PICK $CACHE/wallpaper

hyprctl hyprpaper unload all
hyprctl hyprpaper preload $PICK
hyprctl hyprpaper wallpaper ", ${PICK}"
