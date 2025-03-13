#!/bin/bash

poll=$(nmcli -t -f ACTIVE,SIGNAL device wifi)
active=$(echo "$poll" | grep yes | awk -F ':' '{print $2}')

if [[ -n "$active" ]]; then
    icons=("󰤯" "󰤟" "󰤢" "󰤥" "󰤨")
    idx=$(( $active * 4 / 100 ))
    echo "${icons[$idx]}"
else
    echo "󰤮"
fi
