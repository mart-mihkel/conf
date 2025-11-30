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
set smarttab
set undofile
set path+=**
set number
set hidden

syntax on
filetype plugin on
colorscheme habamax

nnoremap Y y$
nnoremap D d$

nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

nnoremap <c-d> <c-d>zz
nnoremap <c-u> <c-u>zz
nnoremap <c-n> :silent! cnext<cr>
nnoremap <c-p> :silent! cprevious<cr>

nnoremap <leader>e :args<cr>
nnoremap <leader>a :argadd %<cr>:argdedupe<cr>
nnoremap <c-h> :silent! 1argument<cr>
nnoremap <c-j> :silent! 2argument<cr>
nnoremap <c-k> :silent! 3argument<cr>
nnoremap <c-l> :silent! 4argument<cr>

nnoremap <space> <nop>
nnoremap <leader>gf :%s/\s\+$//e<cr>
nnoremap <leader>fo :browse oldfiles<cr>
nnoremap <leader>ff :find<space>
