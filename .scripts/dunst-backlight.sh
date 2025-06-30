#!/usr/bin/env bash

brightnessctl s $1
brightness=$(brightnessctl -m | awk -F , '{print $4}' | tr -d %)
tag="string:x-dunst-stack-tag:brightness"
dunstify -u low -h $tag "bkl $brightness%"
