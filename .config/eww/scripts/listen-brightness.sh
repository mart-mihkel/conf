#!/bin/bash

BRIGHTNESS="/sys/class/backlight/intel_backlight/brightness"

echo_percentage() {
    RAW=$(cat $BRIGHTNESS)
    printf "%.0f\n" $((RAW / 75))
}

echo_percentage
inotifywait -q -m -e close_write $BRIGHTNESS | while read -r; do
    echo_percentage
done
