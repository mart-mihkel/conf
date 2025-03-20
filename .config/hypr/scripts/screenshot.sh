#!/bin/bash

geometry=$(slurp)

if [[ -z "$geometry" ]]; then
    exit 1
fi

stamp=$(date +%H%M%S-%b%d)
name="grim-$stamp.png"
dir="$HOME/Pictures/screenshots"

mkdir --parents "$dir"

grim -g "$geometry" - | wl-copy -t image/png
wl-paste > "$dir/$name"

dunstify -u low "Screenshot" "Saved as $name"
