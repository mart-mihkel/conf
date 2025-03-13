#!/bin/bash

poll=$(bluetoothctl devices)
macs=$(echo "$poll" | awk '{print $2}')

echo "$macs" | while read -r mac; do
    info=$(bluetoothctl info $mac)
    connected=$(echo "$info" | grep Connected | awk '{print $2}')

    if [[ "$connected" != "yes" ]]; then
        continue
    fi

    battery=$(echo "$info" | grep Battery | awk '{print $4}' | tr -d '()')

    if [[ -z "$battery" ]]; then
        echo "󰂱"
    else
        icons=("󰤾" "󰤿" "󰥀" "󰥁" "󰥂" "󰥃" "󰥄" "󰥅" "󰥆" "󰥈")
        idx=$(( battery * 9 / 100 ))
        echo "${icons[$idx]}"
    fi

    exit 3
done

if [[ $? != 3 ]]; then
    echo "󰂯"
fi
