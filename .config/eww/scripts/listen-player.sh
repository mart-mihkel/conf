#!/bin/bash

format="{{duration(position)}}|{{duration(mpris:length)}}"
playerctl -p spotify -F -f $format metadata | while read -r line; do
    echo $line
done
