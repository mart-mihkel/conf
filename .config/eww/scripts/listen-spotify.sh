#!/bin/bash

FORMAT='{"status":"{{status}}","title":"{{title}}","artist":"{{artist}}","position":"{{duration(position)}}","length":"{{duration(mpris:length)}}"}'

playerctl -p spotify -F -f $FORMAT metadata | while read -r LINE; do
    [[ -z "$LINE" ]] && echo '{"status":null}' || echo $LINE
done
