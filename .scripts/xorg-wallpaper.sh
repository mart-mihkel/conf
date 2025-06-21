#!/usr/bin/env bash

wals="git/wallpapers"
pick="$wals/$(ls "$wals" | grep -E 'jpg|jpeg|png' | rofi -dmenu)"
[[ "$pick" == "$wals/" ]] && exit 1

cp -f $pick ~/.cache/wallpaper

pkill feh
feh --no-fehbg --bg-fill $pick &
