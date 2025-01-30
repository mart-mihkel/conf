#!/bin/bash

notify_sink() {
    CURRENT=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | tr -d %)
    MUTE=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
    TAG="string:x-dunst-stack-tag:volume"
    PROGRESS="int:value:$CURRENT"

    if [[ $MUTE == "yes" ]]; then
        ICON="󰖁"
        CURRENT="muted"
    elif [[ $CURRENT -gt 70 ]]; then
        ICON="󰕾"
    elif [[ $CURRENT -gt 35 ]]; then
        ICON="󰖀"
    else
        ICON="󰕿"
    fi

    dunstify -u low -h $PROGRESS -h $TAG "$ICON $CURRENT"
}

notify_source() {
    MUTE=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')
    TAG="string:x-dunst-stack-tag:mic"

    if [[ $MUTE == "yes" ]]; then
        ICON="󰍭"
        CURRENT="muted"
    else
        ICON="󰍬"
        CURRENT="on"
    fi

    dunstify -u low -h $TAG "$ICON $CURRENT"
}


if [[ "$1" == "-i" ]]; then
    pactl set-sink-volume @DEFAULT_SINK@ +2%
    notify_sink
elif [[ "$1" == "-d" ]]; then
    pactl set-sink-volume @DEFAULT_SINK@ -2%
    notify_sink
elif [[ "$1" == "-t" ]]; then
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    notify_sink
elif [[ "$1" == "-m" ]]; then
    pactl set-source-mute @DEFAULT_SOURCE@ toggle
    notify_source
fi
