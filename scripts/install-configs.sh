#!/usr/bin/env bash

mkdir -pv ~/.local/bin
mkdir -pv ~/.config
mkdir -pv ~/.cache
mkdir -pv ~/Pictures

cp -rv ./config/* ~/.config
cp -rv ./assets/walls ~/Pictures

cp -v ./bin/* ~/.local/bin
cp -v ./assets/emojis.txt ~/.cache/
