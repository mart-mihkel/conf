#!/bin/bash

stamp=$(date +%H%M%S-%b%d)
name="maim-$stamp.png"
dir="$HOME/Pictures/screenshots"

mkdir --parents "$dir"

maim -s | xclip -selection clipboard -t image/png
xclip -selection clipboard -t image/png -o > "$dir/$name"

dunstify -u low "Screenshot" "Saved as $name"
