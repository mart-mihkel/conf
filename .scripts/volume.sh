#!/usr/bin/env bash

if [[ "$(pactl get-sink-mute @DEFAULT_SINK@ | grep -Eoe 'no|yes')" = 'yes' ]]; then
  echo "vol off"
  exit
fi

volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}')
echo "vol $volume"
