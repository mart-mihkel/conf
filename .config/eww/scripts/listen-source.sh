#!/bin/bash

query_sources() {
    DEFAULT=$(pactl -f json get-default-source)
    pactl -f json list sources | jq -c --arg default "$DEFAULT" '[ .[] | {
        id: .name,
        mute: .mute,
        name: .description,
        default: (.name == $default),
        volume: .volume["front-left"].value_percent | sub("%"; "")
    }]'
}

query_default_source() {
    DEFAULT=$(pactl -f json get-default-source)
    pactl -f json list sources | jq -c --arg default "$DEFAULT" '.[] | select(.name == $default) | {
        mute: .mute,
        state: .state
    }'
}

[[ "$1" == "-d" ]] && QUERY=query_default_source || QUERY=query_sources

$QUERY
pactl subscribe | while read -r LINE; do
    echo "$LINE" | grep -q -e "'change' on source " -e "'change' on server" && $QUERY
done

