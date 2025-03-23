#!/bin/bash

notify() {
    brightness=$(brightnessctl -m | awk -F , '{print $4}' | tr -d %)
    tag="string:x-dunst-stack-tag:brightness"
    progress="int:value:$brightness"

    icons=("󰃞" "󰃟" "󰃠")
    idx=$(( brightness * 3 / 100 ))

    dunstify -u low -h $tag "${icons[$idx]} $brightness"
}

if [[ "$1" == "-i" ]]; then
    brightnessctl s +2%
    notify
elif [[ "$1" == "-d" ]]; then
    brightnessctl s 2%-
    notify
fi
