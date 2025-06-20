#!/usr/bin/env bash

geometry=$(slurp)
[[ -z "$geometry" ]] && exit 1

name="$(date +%b%d%h%m%s | tr '[:upper:]' '[:lower:]').png"
dir="Pictures/screenshots"
target="$dir/$name"
mkdir -p "$dir"

grim -g "$geometry" - | wl-copy -t image/png
wl-paste > "$target"

action=$(dunstify -a "preview,feh" -u low -i "$target" "screenshot" "saved as $name")
[[ "$action" == "2" ]] && feh $target
