#!/bin/bash

WALLPAPERS="$HOME/Pictures/wallpapers"
PICK=$(ls "$WALLPAPERS" | rofi -dmenu)

if [[ ! -z $PICK ]]; then
    hyprctl hyprpaper preload "${WALLPAPERS}/${PICK}"
    hyprctl hyprpaper wallpaper ", ${WALLPAPERS}/${PICK}"
fi

