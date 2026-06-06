#!/usr/bin/env bash

set -euo pipefail

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

FONTDIR="${HOME}/.local/share/fonts"
TMPDIR="$(mktemp -d)"

trap 'rm -rf "${TMPDIR}"' EXIT

echo -e "${CYAN}==>${NC} ${GREEN}Creating font directory...${NC}"
mkdir -p "${FONTDIR}"

echo -e "${CYAN}==>${NC} ${GREEN}Downloading JetBrainsMono NerdFont...${NC}"
wget -q "wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz" -O "${TMPDIR}/jetbrains-mono.tar.xz"

echo -e "${CYAN}==>${NC} ${GREEN}Extracting fonts...${NC}"
tar -xf "${TMPDIR}/jetbrains-mono.tar.xz" -C "${FONTDIR}"

echo -e "${CYAN}==>${NC} ${GREEN}Updating font cache...${NC}"
fc-cache -f

echo -e "${CYAN}==>${NC} ${GREEN}Done.${NC}"
