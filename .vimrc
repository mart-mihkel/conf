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

noremap <space> <nop>

noremap Y y$
noremap D d$
noremap j gj
noremap k gk
noremap <c-d> <c-d>zz
noremap <c-u> <c-u>zz

nnoremap <c-h> :1argu<cr>
nnoremap <c-j> :2argu<cr>
nnoremap <c-k> :3argu<cr>
nnoremap <c-l> :4argu<cr>
nnoremap <leader>e :args<cr>
nnoremap <leader>a :arga %<cr>
nnoremap <leader>d :argd %<cr>

nnoremap <leader>ff :find<space>
nnoremap <leader>fo :browse oldfiles<cr>
nnoremap <leader>gf :%s/\s\+$//e<cr>
