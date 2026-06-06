#!/usr/bin/env bash

set -euo pipefail

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

TMPDIR="$(mktemp -d)"
trap 'rm -rf "${TMPDIR}"' EXIT

echo -e "${CYAN}==>${NC} ${GREEN}Downloading Neovim stable...${NC}"
wget -q "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz" -O "${TMPDIR}/nvim-linux-x86_64.tar.gz"

echo -e "${CYAN}==>${NC} ${GREEN}Extracting...${NC}"
tar -xzf "${TMPDIR}/nvim-linux-x86_64.tar.gz" -C "${TMPDIR}"

echo -e "${CYAN}==>${NC} ${GREEN}Installing to ~/.nvim...${NC}"
rm -rf ~/.nvim
mv "${TMPDIR}/nvim-linux-x86_64" ~/.nvim

echo -e "${CYAN}==>${NC} ${GREEN}Done.${NC}"
