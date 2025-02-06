#!/bin/bash

set_dark() {
    WAL_FLAG="--cols16 darken"
    GNOME_COLOR="prefer-dark"
    GTK="Adawaita-dark"
}

set_light() {
    WAL_FLAG="-l --cols16 lighten"
    GNOME_COLOR="prefer-light"
    GTK="Adawaita"
}

apply() {
    [[ "$PICK" == "$WALLPAPERS/" ]] && exit 1

    wal $WAL_FLAG -n -q -e -i $PICK

    cp -f $PICK $WAL_CACHE/wallpaper
    cp -f $WAL_CACHE/colors-dunst $CFG/dunst/dunstrc

    eww reload &

    pkill dunst
    hyprctl dispatch exec dunst &

    hyprctl hyprpaper unload all
    hyprctl hyprpaper preload $PICK
    hyprctl hyprpaper wallpaper ", ${PICK}"

    gsettings set org.gnome.desktop.interface gtk-theme $GTK
    gsettings set org.gnome.desktop.interface color-scheme $GNOME_COLOR
}

CFG="${HOME}/.config"
WAL_CACHE="${HOME}/.cache/wal"
WALLPAPERS="${HOME}/Pictures/wallpapers"

if [[ "$1" == "-l" ]]; then
    PICK="${WALLPAPERS}/$(ls "$WALLPAPERS" | rofi -dmenu -p '󰥷 ')"
    set_light
    apply
elif [[ "$1" == "-d" ]]; then
    PICK="${WALLPAPERS}/$(ls "$WALLPAPERS" | rofi -dmenu -p '󰥷 ')"
    set_dark
    apply
elif [[ "$1" == "-s" ]]; then
    PICK="$(cat $HOME/.cache/wal/wal)"
    LAST=$(cat $HOME/.cache/wal/last_used_theme | awk -F _ '{print $10}')

    if [[ "$LAST" == "dark" ]]; then
        set_light
    else
        set_dark
    fi

    apply
else
    echo "usage: wallpaper.sh [-l | -d | -s]"
fi
