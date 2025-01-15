#!/bin/bash

WALLPAPERS="${HOME}/Pictures/wallpapers"
PICK="${WALLPAPERS}/$(ls "$WALLPAPERS" | rofi -dmenu)"
CACHE="${HOME}/.cache/wallpaper"

if [[ ! -z $PICK ]]; then
    cp -f $PICK $CACHE

    hyprctl hyprpaper preload $PICK
    hyprctl hyprpaper wallpaper ", ${PICK}"
fi

