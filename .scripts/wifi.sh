#!/usr/bin/env bash

if [[ "$(cat /sys/class/net/wlp2s0/operstate)" = 'down' ]]; then
    echo "net off"
    exit
fi

quality=$(iw dev wlp2s0 link | grep 'dBm$' | grep -Eoe '-[0-9]{2}' | awk '{print  ($1 > -50 ? 100 :($1 < -100 ? 0 : ($1+100)*2))}')
echo "net $quality%"
