#!/usr/bin/env bash

# shellcheck source=/dev/null
source "$HOME/.config/sketchybar/colors.sh"

SID="$1"

FOCUSED=$(yabai -m query --spaces 2>/dev/null | jq -r '.[] | select(."has-focus" == true) | .index' | head -1)

if [ "$SID" = "$FOCUSED" ]; then
    sketchybar --set "$NAME" \
        icon.color="$FOREGROUND" \
        icon.font="JetBrainsMono Nerd Font:Bold:12"
else
    sketchybar --set "$NAME" \
        icon.color="$FOREGROUND_DIM" \
        icon.font="JetBrainsMono Nerd Font:Regular:12"
fi
