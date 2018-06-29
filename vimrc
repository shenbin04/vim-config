" Plug
call plug#begin('~/.vim/bundle')
Plug 'SirVer/ultisnips'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --tern-completer' }
Plug 'airblade/vim-gitgutter'
Plug 'alvan/vim-closetag'
Plug 'b4winckler/vim-objc'
Plug 'benmills/vimux'
Plug 'bps/vim-textobj-python'
Plug 'bronson/vim-visual-star-search'
Plug 'cakebaker/scss-syntax.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'easymotion/vim-easymotion'
Plug 'elzr/vim-json'
Plug 'gerw/vim-HiLinkTrace'
Plug 'godlygeek/tabular'
Plug 'hail2u/vim-css3-syntax'
Plug 'honza/vim-snippets'
Plug 'janko-m/vim-test'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
Plug 'keith/swift.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'majutsushi/tagbar'
Plug 'maksimr/vim-jsbeautify'
Plug 'mhinz/vim-grepper'
Plug 'michaeljsmith/vim-indent-object'
Plug 'millermedeiros/vim-esformatter'
Plug 'mxw/vim-jsx'
Plug 'nviennot/molokai'
Plug 'pangloss/vim-javascript'
Plug 'plasticboy/vim-markdown'
Plug 'scrooloose/nerdtree'
Plug 'sjl/gundo.vim'
Plug 'solarnz/thrift.vim'
Plug 'terryma/vim-expand-region'
Plug 'tmhedberg/SimpylFold'
Plug 'ton/vim-bufsurf'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-python/python-syntax'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/L9'
Plug 'vim-scripts/YankRing.vim'
Plug 'vim-scripts/nginx.vim'
Plug 'w0rp/ale'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'
Plug 'yssl/QFEnter'
call plug#end()

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
set updatetime=100
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
