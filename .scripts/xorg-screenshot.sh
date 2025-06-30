#!/usr/bin/env bash

name="$(date +%b%d%H%M%S | tr '[:upper:]' '[:lower:]').png"
dir="$HOME/pictures/screenshots"
target="$dir/$name"
mkdir --parents "$dir"

maim -s | xclip -selection clipboard -t image/png
xclip -selection clipboard -t image/png -o > "$target"

action=$(dunstify -A "preview,feh" -u low -I "$target" "Screenshot" "Saved as $name")
[[ "$action" == "2" ]] && feh $target
