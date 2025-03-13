#!/bin/bash

notify() {
    brightness=$(brightnessctl -m | awk -F , '{print $4}' | tr -d %)
    tag="string:x-dunst-stack-tag:brightness"
    progress="int:value:$brightness"

    if [[ $brightness -gt 66 ]]; then
        icon="󰃠"
    elif [[ $brightness -gt 33 ]]; then
        icon="󰃟"
    else
        icon="󰃞"
    fi

    dunstify -u low -h $progress -h $tag "$icon $brightness"
}

if [[ "$1" == "-i" ]]; then
    brightnessctl s +2%
    notify
elif [[ "$1" == "-d" ]]; then
    brightnessctl s 2%-
    notify
fi
