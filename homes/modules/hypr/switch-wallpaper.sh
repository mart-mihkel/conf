#!/bin/bash

CFG="${HOME}/.config"
WAL_CACHE="${HOME}/.cache/wal"
WALLPAPERS="${HOME}/Pictures/wallpapers"
PICK="${WALLPAPERS}/$(ls "$WALLPAPERS" | rofi -dmenu)"

if [[ "$1" == "-l" ]]; then
    WAL_FLAG="-l --cols16 lighten"
    GNOME_COLOR="prefer-light"
    GTK="Adawaita"
else
    WAL_FLAG=""
    GNOME_COLOR="prefer-dark"
    GTK="Adawaita-dark"
fi

if [[ -f $PICK ]]; then
    wal $WAL_FLAG -nei $PICK

    cp -f $PICK $WAL_CACHE/wallpaper
    cp -f $WAL_CACHE/colors-btop.theme $CFG/btop/themes/pywal.theme

    hyprctl hyprpaper unload all
    hyprctl hyprpaper preload $PICK
    hyprctl hyprpaper wallpaper ", ${PICK}"

    pkill eww
    eww open bar-win &

    pkill dunst
    dunst -config $WAL_CACHE/dunstrc &

    gsettings set org.gnome.desktop.interface gtk-theme $GTK
    gsettings set org.gnome.desktop.interface color-scheme $GNOME_COLOR
fi
