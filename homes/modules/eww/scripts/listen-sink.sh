#!/bin/bash

query_sinks() {
    DEFAULT=$(pactl -f json get-default-sink)
    pactl -f json list sinks | jq -c --arg default "$DEFAULT" '[ .[] | {
        id: .name,
        mute: .mute,
        name: .description,
        default: (.name == $default),
        volume: .volume["front-left"].value_percent
    }]'
}

query_sinks

pactl subscribe | while read -r LINE; do
    echo "$LINE" | grep -q "'change' on sink " && query_sinks
done

