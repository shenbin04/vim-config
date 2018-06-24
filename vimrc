" Pathogen
execute pathogen#infect()

" General
syntax on
filetype plugin indent on
set nocompatible
set number
set relativenumber
set hidden
set cursorline
set cursorcolumn
set updatecount=100
set directory=~/.vim/swap
set diffopt=filler,iwhite
set history=1000
set scrolloff=3
set visualbell
set shortmess+=A
set foldlevelstart=99
set pastetoggle=<F1>
set ttimeoutlen=0
set updatetime=1000
set encoding=utf-8
set foldmethod=indent
set tags+=tags;$HOME
set viewoptions=folds,cursor
set showmatch

" Formatting
set autoindent
set smartindent
set smarttab
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set textwidth=120
set colorcolumn=+1
set conceallevel=2
set formatoptions-=t formatoptions+=croqlj

" Command completion
set wildmenu
set wildmode=list:longest,full

" Whitespace
set list
set listchars=tab:▸\ ,trail:•,extends:»,precedes:«

" Search
set ignorecase
set smartcase
set hlsearch
set incsearch

" Viminfo
set viminfo='100,/100,h,\"500,:500
if !has('nvim')
  set viminfo+=n~/.vim/viminfo
endif

" Undo
set undofile
set undodir=~/.vim/undo
set undolevels=1000

" Color
runtime! common/color.vim

" Mapping
runtime! common/mapping.vim

" Autocmd
runtime! common/autocmd.vim

" Plugin
runtime! common/plugin.vim

" Local
runtime! ./vimrc.local
