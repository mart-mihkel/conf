#!/bin/bash

GEOM=$(slurp)

if [[ -z "$GEOM" ]]; then
    exit 1
fi

grim -g "$GEOM"
grim -g "$GEOM" - | wl-copy -t image/png

dunstify -u low "Screenshot" "Saved to ~/Pictures\nCopied to clipboard"
