#!/bin/bash

query_sources() {
    DEFAULT=$(pactl -f json get-default-source)
    pactl -f json list sources | jq -c --arg default "$DEFAULT" '[ .[] | {
        id: .name,
        mute: .mute,
        name: .description,
        default: (.name == $default),
        volume: .volume["front-left"].value_percent
    }]'
}

query_sources

pactl subscribe | while read -r LINE; do
    echo "$LINE" | grep -q -e "'change' on source " -e "'change' on server" && query_sources
done

