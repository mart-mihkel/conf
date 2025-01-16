#!/bin/bash

WALLPAPERS="${HOME}/Pictures/wallpapers"
PICK="${WALLPAPERS}/$(ls "$WALLPAPERS" | rofi -dmenu)"
CACHE="${HOME}/.cache/wallpaper"

if [[ -f $PICK ]]; then
    cp -f $PICK $CACHE

    hyprctl hyprpaper preload $PICK
    hyprctl hyprpaper wallpaper ", ${PICK}"
fi

