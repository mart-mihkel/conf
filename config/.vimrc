let mapleader=" "
let g:netrw_banner=0

set wildignore=*.pyc,*.o,*/node_modules/*,*/.venv/*
set viminfofile=~/.vim/viminfo
set clipboard+=unnamedplus
set complete=.,w,b,u,t
set backupdir=~/.vim
set directory=~/.vim
set undolevels=10000
set undodir=~/.vim
set encoding=utf-8
set colorcolumn=80
set relativenumber
set history=10000
set softtabstop=4
set nocompatible
set laststatus=2
set shiftwidth=4
set breakindent
set scrolloff=4
set autoindent
set copyindent
set ignorecase
set noswapfile
set cursorline
set splitright
set splitbelow
set shiftround
set expandtab
set smartcase
set incsearch
set showmatch
set tabstop=4
set smarttab
set wildmenu
set undofile
set showmode
set path+=**
set showcmd
set backup
set number
set nowrap
set hidden
set ruler
set list

syntax on
filetype plugin on
colorscheme habamax

nnoremap <space> <nop>
nnoremap <leader>gf :%s/\s\+$//e<CR>
nnoremap Y y$
nnoremap D d$
