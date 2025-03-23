#!/bin/bash

function lock() {
    if [[ "$XDG_CURRENT_DESKTOP" == "Hyprland" ]]; then
        hyprlock
    elif [[ "$XDG_CURRENT_DESKTOP" == "i3" ]]; then
        xlock -mode blank
    fi
}

playerctl -a pause &

if [[ "$1" == "-s" ]]; then
    lock &
    systemctl suspend
elif [[ "$1" == "-l" ]]; then
    lock
else
    echo "Usage $0 [suspend | lock]"
fi
