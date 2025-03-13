#!/bin/bash

poll-source() {
    source=$(pactl -f json get-default-source)
    mute=$(pactl -f json list sources | jq -c --arg default "$source" '.[] | select(.name == $default) | .mute')

    if [[ "$mute" == "true" ]]; then
        echo "󰍭"
    else
        echo "󰍬"
    fi
}

poll-source
