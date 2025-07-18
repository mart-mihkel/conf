#!/usr/bin/env bash

TOUCHPAD="$(xinput list --name-only | grep -i touchpad)"

xinput set-prop "$TOUCHPAD" "libinput Tapping Enabled" 1

xset r rate 256 32
xset m 0 0

setxkbmap -layout ee -variant nodeadkeys

exec i3
