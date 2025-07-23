set nocompatible
set encoding=utf-8

set number
set relativenumber

set hidden
set path+=**
set wildmenu
set wildignore=*.swp,*.bak,*.pyc,*.class,*.o,*/node_modules/*,*/.venv/*
set complete=.,w,b,u,t
set clipboard+=unnamedplus

set tabstop=4
set shiftwidth=4
set softtabstop=4
set shiftround
set expandtab
set smarttab

set autoindent
set copyindent
set breakindent

set ignorecase
set smartcase

set history=1000
set undolevels=1000
set undofile
set swapfile backup undofile
set undodir=~/.local/state/vim
set backupdir=~/.local/state/vim
set directory=~/.local/state/vim
set viminfofile=~/.local/state/vim/viminfo

set ruler
set nowrap
set showcmd
set showmode
set incsearch
set showmatch
set cursorline
set scrolloff=4

set list
set listchars=tab:··,trail:·

set splitright
set splitbelow
set laststatus=2

syntax on
filetype plugin on
colorscheme habamax

let mapleader=" "
let g:netrw_banner=0

nnoremap <space> <nop>
nnoremap <leader>f :%s/\s\+$//e<CR>

nnoremap <C-D> <C-D>zz
nnoremap <C-U> <C-U>zz

nnoremap Y y$
nnoremap D d$
