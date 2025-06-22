#!/usr/bin/env bash

playerctl -a pause
swaylock \
  --daemonize \
  --image               ~/.cache/wallpaper \
  --indicator-radius    32 \
  --indicator-thickness 4 \
  --font-size           16 \
  --font                "cozette" \
  --inside-color        00000000 \
  --inside-clear-color  00000000 \
  --inside-ver-color    00000000 \
  --inside-wrong-color  00000000 \
  --key-hl-color        a3be8c80 \
  --line-color          00000000 \
  --line-clear-color    00000000 \
  --line-ver-color      00000000 \
  --line-wrong-color    00000000 \
  --ring-color          00000000 \
  --ring-clear-color    00000000 \
  --ring-ver-color      00000000 \
  --ring-wrong-color    00000000 \
  --separator-color     00000000 \
  --text-color          d8dee9 \
  --text-clear-color    d8dee9 \
  --text-ver-color      a3be8c \
  --text-wrong-color    bf616a

