#!/usr/bin/env bash

TOUCHPAD="$(xinput list --name-only | grep -i touchpad)"

xinput set-prop "$TOUCHPAD" "libinput Tapping Enabled" 1
setxkbmap -layout ee -variant nodeadkeys
xset r rate 256 32
exec i3
