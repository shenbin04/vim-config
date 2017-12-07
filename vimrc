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

" Search
set ignorecase
set smartcase
set hlsearch
set incsearch
set showmatch

" Mapping
let mapleader = ","
let localmapleader = ","

nnoremap _ :split<cr>
nnoremap \| :vsplit<cr>

nnoremap <Up>    2<C-w>-
nnoremap <Down>  2<C-w>+
nnoremap <Left>  2<C-w><
nnoremap <Right> 2<C-w>>

nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

nnoremap <Leader>q :q<CR>

" Fugitive
nnoremap <silent> <Leader>gs :Gstatus<CR>
nnoremap <silent> <Leader>gc :Gcommit<CR>
nnoremap <silent> <Leader>gd :Gdiff<CR>
nnoremap <silent> <Leader>gb :Gblame<CR>
nnoremap <silent> <Leader>gr :Gread<CR>
nnoremap <silent> <Leader>gl :Glog -- %<CR>
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif
