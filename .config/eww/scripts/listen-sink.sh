#!/bin/bash

query_sinks() {
    DEFAULT=$(pactl -f json get-default-sink)
    pactl -f json list sinks | jq -c --arg default "$DEFAULT" '[ .[] | {
        id: .name,
        mute: .mute,
        name: .description,
        default: (.name == $default),
        volume: .volume["front-left"].value_percent | sub("%"; "")
    }]'
}

query_default_sink() {
    DEFAULT=$(pactl -f json get-default-sink)
    pactl -f json list sinks | jq -c --arg default "$DEFAULT" '.[] | select(.name == $default) | {
        mute: .mute,
        volume: .volume["front-left"].value_percent | sub("%"; "")
    }'
}

[[ "$1" == "-d" ]] && QUERY=query_default_sink || QUERY=query_sinks

$QUERY
pactl subscribe | while read -r LINE; do
    echo "$LINE" | grep -q "'change' on sink " && $QUERY
done

