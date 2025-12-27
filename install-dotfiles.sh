#!/usr/bin/env bash

ESC="\033"
FG2="${ESC}[38;5;2m"
RES="${ESC}[0m"

BIN=$HOME/.local/bin
CFG=$HOME/.config

set -e

printf "${FG2}copying dotfiles!${RES}\n"

mkdir -pv $BIN $CFG
cp -rv bin/* $BIN
cp -rv config/* $CFG
cp -v .tmux.conf $HOME
cp -v .vimrc $HOME
cp -v .zshrc $HOME
