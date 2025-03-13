#!/bin/bash

notify() {
    brightness=$(brightnessctl -m | awk -F , '{print $4}' | tr -d %)
    progress="int:value:$brightness"
    tag="string:x-dunst-stack-tag:brightness"

    if [[ $brightness -gt 66 ]]; then
        icon="󰃠"
    elif [[ $brightness -gt 33 ]]; then
        icon="󰃟"
    else
        icon="󰃞"
    fi

    dunstify -u low -h $tag "$icon $brightness"
}

if [[ "$1" == "-i" ]]; then
    brightnessctl s +2%
    notify
elif [[ "$1" == "-d" ]]; then
    brightnessctl s 2%-
    notify
fi
