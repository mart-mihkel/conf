let mapleader=' '
let g:netrw_banner=0
let g:netrw_preview=1

set viminfofile=~/.vim/info
set backupdir=~/.vim
set directory=~/.vim
set undodir=~/.vim
set encoding=utf-8
set relativenumber
set termguicolors
set nocompatible
set shiftwidth=4
set scrolloff=4
set autoindent
set ignorecase
set noswapfile
set splitright
set splitbelow
set expandtab
set smartcase
set incsearch
set tabstop=4
set smarttab
set undofile
set path+=**
set number
set hidden

syntax on
filetype plugin on

nnoremap Y y$
nnoremap D d$

nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

nnoremap <c-d> <c-d>zz
nnoremap <c-u> <c-u>zz
vnoremap <c-d> <c-d>zz
vnoremap <c-u> <c-u>zz

nnoremap <c-n> :cnext<cr>
nnoremap <c-p> :cprevious<cr>
nnoremap <c-t> :tabnew %<cr>
nnoremap <c-h> 1gt
nnoremap <c-j> 2gt
nnoremap <c-k> 3gt
nnoremap <c-l> 4gt

nnoremap <space> <nop>
nnoremap <leader>gf :%s/\s\+$//e<cr>
nnoremap <leader>fo :browse oldfiles<cr>
nnoremap <leader>ff :find<space>
