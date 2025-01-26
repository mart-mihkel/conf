#!/bin/bash

query_default_source() {
    DEFAULT=$(pactl -f json get-default-source)
    pactl -f json list sources | jq -c --arg default "$DEFAULT" '.[] | select(.name == $default) | {
        mute: .mute,
        state: .state
    }'
}

query_default_source

pactl subscribe | while read -r LINE; do
    echo "$LINE" | grep -q -e "'change' on source " -e "'change' on server " && query_default_source
done

