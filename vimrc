" Pathogen
execute pathogen#infect()

" Auto reload vimrc
autocmd BufWritePost .vimrc,vimrc source $MYVIMRC

" General
syntax on
set number
set relativenumber
set hidden

" Formatting
filetype plugin indent on
set autoindent smartindent
set smarttab
set expandtab
set tabstop=2
set shiftwidth=2
set textwidth=120
set colorcolumn=+1
set formatoptions-=t formatoptions+=croql

" Color
colorscheme molokai

" Whitespace
set list
set listchars=tab:▸\ ,trail:•,extends:»,precedes:«
