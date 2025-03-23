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
pactl subscribe | while read -r line; do
    echo "$line" | grep -q -e "'change' on source " -e "'change' on server" && poll-source
done
