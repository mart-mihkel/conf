#!/bin/bash

geometry=$(slurp)

if [[ -z "$geometry" ]]; then
    exit 1
fi

grim -g "$geometry"
grim -g "$geometry" - | wl-copy -t image/png

dunstify -u low "Screenshot" "Saved to ~/Pictures\nCopied to clipboard"
