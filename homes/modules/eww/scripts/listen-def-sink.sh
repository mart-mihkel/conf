#!/bin/bash

query_default_sink() {
    DEFAULT=$(pactl -f json get-default-sink)
    pactl -f json list sinks | jq -c --arg default "$DEFAULT" '.[] | select(.name == $default) | {
        mute: .mute,
        volume: .volume["front-left"].value_percent
    }'
}

query_default_sink

pactl subscribe | while read -r LINE; do
    echo "$LINE" | grep -q "'change' on sink " && query_default_sink
done
