#!/bin/bash

echo_usage() {
    echo "wallpaper [-rl | -rd | -m]"
}

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

CFG="${HOME}/.config"
WAL_CACHE="${HOME}/.cache/wal"
WALLPAPERS="${HOME}/Pictures/wallpapers"

if [[ "$1" == "-rl" ]]; then # rofi light
    PICK="${WALLPAPERS}/$(ls "$WALLPAPERS" | rofi -dmenu)"
    set_light
elif [[ "$1" == "-rd" ]]; then # rofi dark
    PICK="${WALLPAPERS}/$(ls "$WALLPAPERS" | rofi -dmenu)"
    set_dark
elif [[ "$1" == "-m" ]]; then # mode switch
    PICK="$(cat $HOME/.cache/wal/wal)"

    if cat $HOME/.cache/wal/last_used_theme | grep -q "dark"; then
        set_light
    else
        set_dark
    fi
fi

if [[ -f $PICK ]]; then
    wal $WAL_FLAG -nqstei $PICK

    cp -f $PICK $WAL_CACHE/wallpaper
    cp -f $WAL_CACHE/colors-btop.theme $CFG/btop/themes/pywal.theme

    hyprctl hyprpaper unload all
    hyprctl hyprpaper preload $PICK
    hyprctl hyprpaper wallpaper ", ${PICK}"

    eww reload

    pkill dunst
    hyprctl dispatch exec "dunst -config $WAL_CACHE/dunstrc"

    gsettings set org.gnome.desktop.interface gtk-theme $GTK
    gsettings set org.gnome.desktop.interface color-scheme $GNOME_COLOR
else
    echo_usage
fi
