#!/usr/bin/env bash

wget "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz"
tar -xzvf nvim-linux-x86_64.tar.gz
rm -v nvim-linux-x86_64.tar.gz
mv -v nvim-linux-x86_64 ~/.nvim
