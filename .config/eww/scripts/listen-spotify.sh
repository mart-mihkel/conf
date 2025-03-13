#!/bin/bash

format='{"status":"{{status}}","position":"{{duration(position)}}","length":"{{duration(mpris:length)}}"}'

playerctl -p spotify -F -f $format metadata | while read -r line; do
    [[ -z "$line" ]] && echo '{"status":null}' || echo $line
done
