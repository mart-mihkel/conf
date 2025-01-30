#!/bin/bash

DEFAULT="{"is_day":0,"temperature_2m":0,"wind_speed_10m":0,"snowfall":0,"rain":0,"cloud_cover":0}"
URL="https://api.open-meteo.com/v1/forecast?latitude=58.3806&longitude=26.7251&current=temperature_2m,is_day,rain,snowfall,cloud_cover,wind_speed_10m"

MAX_RETRIES=5
RETRIES=0

while true; do
  WEATHER=$(curl -m 5 -s $URL)
  CODE=$?

  if [[ $CODE == 0 ]]; then
    echo $WEATHER | jq -c '.current'
    exit 0
  fi

  RETRIES=$((RETRIES + 1))
  if [[ $RETRIES > $MAX_RETRIES ]]; then
    echo $DEFAULT
    exit 1
  fi

done
