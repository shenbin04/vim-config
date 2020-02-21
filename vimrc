" Plug
call plug#begin('~/.vim/bundle')

Plug 'SirVer/ultisnips'
Plug 'airblade/vim-gitgutter'
Plug 'alvan/vim-closetag'
Plug 'b4winckler/vim-objc'
Plug 'bps/vim-textobj-python'
Plug 'cakebaker/scss-syntax.vim'
Plug 'easymotion/vim-easymotion'
Plug 'elzr/vim-json'
Plug 'fakeezz/marvim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'gerw/vim-HiLinkTrace'
Plug 'godlygeek/tabular'
Plug 'hail2u/vim-css3-syntax'
Plug 'hashivim/vim-terraform'
Plug 'honza/vim-snippets'
Plug 'janko-m/vim-test'
Plug 'jiangmiao/auto-pairs'
Plug 'jparise/vim-graphql'
Plug 'junegunn/fzf'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/vim-slash'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
Plug 'keith/swift.vim'
Plug 'leafgarland/typescript-vim'
Plug 'machakann/vim-highlightedyank'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-grepper'
Plug 'mhinz/vim-startify'
Plug 'michaeljsmith/vim-indent-object'
Plug 'mxw/vim-jsx'
Plug 'nviennot/molokai'
Plug 'pangloss/vim-javascript'
Plug 'plasticboy/vim-markdown'
Plug 'psf/black'
Plug 'scrooloose/nerdtree'
Plug 'shenbin04/fzf.vim'
Plug 'shenbin04/neoterm'
Plug 'shenbin04/vim-esformatter', { 'do': 'npm i -g esformatter' }
Plug 'shenbin04/vim-flow-plus'
Plug 'shime/vim-livedown', { 'do': 'npm i' }
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
Plug 'urbainvaes/vim-remembrall'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-python/python-syntax'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/L9'
Plug 'vim-scripts/YankRing.vim', { 'on': 'YRCheckClipboard' }
Plug 'vim-scripts/nginx.vim'
Plug 'vimjas/vim-python-pep8-indent'
Plug 'w0rp/ale'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'
Plug 'yssl/QFEnter'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ternjs/tern_for_vim', { 'do': 'npm i' }
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'davidhalter/jedi-vim', { 'do': 'git submodule update --init --recursive' }
Plug 'carlitux/deoplete-ternjs'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'lighttiger2505/deoplete-vim-lsp'
Plug 'Shougo/neco-vim'
Plug 'ujihisa/neco-look'

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
set diffopt+=vertical
set showmatch
set noautoread
set path+=$HOME/.vim
set completeopt-=preview

" Formatting
set autoindent
set smartindent
set smarttab
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
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
if has('nvim')
  set shada='2000,/500,h,\"500,:2000,n~/.vim/main.shada
else
  set viminfo='2000,/500,h,\"500,:2000,n~/.vim/viminfo
endif

" Undo
set undofile
set undodir=~/.vim/undo
set undolevels=1000

" Color
runtime common/color.vim

" Mapping
runtime common/mapping.vim

" Autocmd
runtime common/autocmd.vim

" Plugin
runtime common/plugin.vim

" Local
runtime vimrc.local
