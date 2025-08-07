let mapleader=" "
let g:netrw_banner=0

set nocompatible
set encoding=utf-8

set wildignore=*.pyc,*.o,*/node_modules/*,*/.venv/*
set viminfofile=~/.vim/viminfo
set listchars=tab:··,trail:·
set clipboard+=unnamedplus
set complete=.,w,b,u,t
set backupdir=~/.vim
set directory=~/.vim
set undodir=~/.vim
set path+=**

set relativenumber
set breakindent
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
set smarttab
set wildmenu
set undofile
set showmode
set showcmd
set backup
set number
set nowrap
set hidden
set ruler
set list

set undolevels=10000
set history=10000
set softtabstop=4
set laststatus=2
set shiftwidth=4
set scrolloff=4
set tabstop=4

syntax on
filetype plugin on
colorscheme habamax

nnoremap <space> <nop>
nnoremap <leader>f :%s/\s\+$//e<CR>

nnoremap <C-D> <C-D>zz
nnoremap <C-U> <C-U>zz

nnoremap Y y$
nnoremap D d$
