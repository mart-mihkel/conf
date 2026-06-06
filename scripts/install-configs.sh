#!/usr/bin/env bash

set -euo pipefail

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}==>${NC} ${GREEN}Creating directories...${NC}"
mkdir -p ~/.local/bin
mkdir -p ~/.config
mkdir -p ~/.cache
mkdir -p ~/Pictures

echo -e "${CYAN}==>${NC} ${GREEN}Copying configs...${NC}"
cp -r ./config/* ~/.config

echo -e "${CYAN}==>${NC} ${GREEN}Copying wallpapers...${NC}"
cp -r ./assets/walls ~/Pictures

echo -e "${CYAN}==>${NC} ${GREEN}Copying scripts...${NC}"
cp ./bin/* ~/.local/bin

echo -e "${CYAN}==>${NC} ${GREEN}Copying assets...${NC}"
cp ./assets/emojis.txt ~/.cache/

echo -e "${CYAN}==>${NC} ${GREEN}Done.${NC}"
