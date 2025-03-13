#!/bin/bash

notify_sink() {
    volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | tr -d %)
    mute=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
    tag="string:x-dunst-stack-tag:volume"
    progress="int:value:$volume"

    if [[ $mute == "yes" ]]; then
        icon="󰖁"
        volume="muted"
    elif [[ $volume -gt 40 ]]; then
        icon="󰕾"
    elif [[ $volume -gt 20 ]]; then
        icon="󰖀"
    else
        icon="󰕿"
    fi

    dunstify -u low -h $progress -h $tag "$icon $volume"
}

notify_source() {
    mute=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')
    tag="string:x-dunst-stack-tag:mic"

    if [[ $mute == "yes" ]]; then
        icon="󰍭"
        volume="muted"
    else
        icon="󰍬"
        volume="unmuted"
    fi

    dunstify -u low -h $tag "$icon $volume"
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
