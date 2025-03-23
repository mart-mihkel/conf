#!/bin/bash

poll=$(nmcli -t -f ACTIVE,SIGNAL,SSID device wifi | grep yes)
active=$(echo "$poll" | awk -F ':' '{print $2}')
ssid=$(echo "$poll" | awk -F ':' '{print $3}')

if [[ -n "$active" ]]; then
    icons=("󰤯" "󰤟" "󰤢" "󰤥" "󰤨")
    idx=$(( $active * 4 / 100 ))
    echo "[\"${icons[$idx]}\",\"$ssid\"]"
else
    echo "[\"󰤮\",\"\"]"
fi
