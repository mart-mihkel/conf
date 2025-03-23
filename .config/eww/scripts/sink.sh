#!/bin/bash

poll-sink() {
    sink=$(pactl -f json get-default-sink)
    info=$(pactl -f json list sinks | jq -c --arg default "$sink" '.[] | select(.name == $default) | {
        mute: .mute,
        volume: .volume["front-left"].value_percent | sub("%"; "")
    }')

    volume=$(echo "$info" | jq '.volume' | tr -d '"')
    if [[ $(echo "$info" | jq '.mute') == "true" ]]; then
        echo "[\"󰖁\",\"$volume\"]"
    else
        icons=("󰕿" "󰖀" "󰕾")
        idx=$(( volume * 3 / 100 ))
        echo "[\"${icons[$idx]}\",\"$volume\"]"
    fi
}

poll-sink
pactl subscribe | while read -r line; do
    echo "$line" | grep -q "'change' on sink " && poll-sink
done

