#!/usr/bin/env bash

wals="$HOME/git/wallpapers"
pick="$wals/$(ls "$wals" | grep -E 'jpg|jpeg|png' | rofi -dmenu)"
[[ "$pick" == "$wals/" ]] && exit 1

hellwal -i $pick
cp -f $pick ~/.cache/wallpaper

dunstctl reload &
pkill -SIGUSR2 waybar &
hyprctl hyprpaper reload ,$pick
