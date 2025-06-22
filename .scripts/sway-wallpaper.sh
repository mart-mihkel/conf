#!/usr/bin/env bash

wals="git/wallpapers"
pick="$wals/$(ls "$wals" | grep -E 'jpg|jpeg|png' | tofi)"
[[ "$pick" == "$wals/" ]] && exit 1

cp -f $pick ~/.cache/wallpaper

pkill swaybg
swaybg -i $pick -m fill &
