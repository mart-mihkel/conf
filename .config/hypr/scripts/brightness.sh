#!/bin/bash

notify() {
    CURRENT=$(brightnessctl -m | awk -F , '{print $4}' | tr -d %)
    PROGRESS="int:value:$CURRENT"
    TAG="string:x-dunst-stack-tag:brightness"

    if [[ $CURRENT -gt 66 ]]; then
        ICON="󰃠"
    elif [[ $CURRENT -gt 33 ]]; then
        ICON="󰃟"
    else
        ICON="󰃞"
    fi

    dunstify -u low -h $TAG "$ICON $CURRENT"
}

if [[ "$1" == "-i" ]]; then
    brightnessctl s +2%
    notify
elif [[ "$1" == "-d" ]]; then
    brightnessctl s 2%-
    notify
fi
