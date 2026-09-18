#!/usr/bin/env bash

PERCENT=$(pmset -g batt | grep -o '[0-9]\{1,3\}%' | head -1 | tr -d '%')
CHARGING=$(pmset -g batt | grep -q 'AC Power' && echo 1 || echo 0)

if [ -z "$PERCENT" ]; then
    exit
fi

if [ "$CHARGING" = "1" ]; then

    if [ "$PERCENT" -ge 90 ]; then
        ICON="󰂅"
    elif [ "$PERCENT" -ge 80 ]; then
        ICON="󰂋"
    elif [ "$PERCENT" -ge 70 ]; then
        ICON="󰂊"
    elif [ "$PERCENT" -ge 60 ]; then
        ICON="󰢞"
    elif [ "$PERCENT" -ge 50 ]; then
        ICON="󰂉"
    elif [ "$PERCENT" -ge 40 ]; then
        ICON="󰢝"
    elif [ "$PERCENT" -ge 30 ]; then
        ICON="󰂈"
    elif [ "$PERCENT" -ge 20 ]; then
        ICON="󰂇"
    elif [ "$PERCENT" -ge 10 ]; then
        ICON="󰂆"
    else
        ICON="󰢜"
    fi

else

    if [ "$PERCENT" -ge 90 ]; then
        ICON="󰁹"
    elif [ "$PERCENT" -ge 80 ]; then
        ICON="󰂂"
    elif [ "$PERCENT" -ge 70 ]; then
        ICON="󰂁"
    elif [ "$PERCENT" -ge 60 ]; then
        ICON="󰂀"
    elif [ "$PERCENT" -ge 50 ]; then
        ICON="󰁿"
    elif [ "$PERCENT" -ge 40 ]; then
        ICON="󰁾"
    elif [ "$PERCENT" -ge 30 ]; then
        ICON="󰁽"
    elif [ "$PERCENT" -ge 20 ]; then
        ICON="󰁼"
    elif [ "$PERCENT" -ge 10 ]; then
        ICON="󰁻"
    else
        ICON="󰁺"
    fi

fi

sketchybar --set battery label="${ICON} ${PERCENT}%"
