" Plug
call plug#begin('~/.vim/bundle')

Plug 'HerringtonDarkholme/yats.vim', {'for': 'javascript'}
Plug 'MaxMEllon/vim-jsx-pretty', {'for': 'javascript'}
Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'Shougo/echodoc.vim'
Plug 'Shougo/neco-vim'
Plug 'SirVer/ultisnips'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'alvan/vim-closetag'
Plug 'b4winckler/vim-objc', {'for': 'objc'}
Plug 'bps/vim-textobj-python', {'for': 'python'}
Plug 'cakebaker/scss-syntax.vim', {'for': 'css'}
Plug 'christoomey/vim-tmux-navigator'
Plug 'dhruvasagar/vim-buffer-history'
Plug 'dhruvasagar/vim-table-mode'
Plug 'easymotion/vim-easymotion'
Plug 'elzr/vim-json', {'for': 'json'}
Plug 'fakeezz/marvim'
Plug 'fatih/vim-go', {'do': ':GoUpdateBinaries', 'for': 'go'}
Plug 'fszymanski/deoplete-emoji'
Plug 'gerw/vim-HiLinkTrace'
Plug 'godlygeek/tabular'
Plug 'hail2u/vim-css3-syntax', {'for': 'css'}
Plug 'hashivim/vim-terraform', {'for': 'terraform'}
Plug 'honza/vim-snippets'
Plug 'iamcco/markdown-preview.nvim', {'do': {-> mkdp#util#install()}}
Plug 'jiangmiao/auto-pairs'
Plug 'jparise/vim-graphql', {'for': 'graphql'}
Plug 'junegunn/gv.vim', {'on': 'GV'}
Plug 'junegunn/vim-easy-align', {'on': ['<Plug>(EasyAlign)', 'EasyAlign']}
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/vim-slash'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
Plug 'kassio/neoterm'
Plug 'keith/swift.vim', {'for': 'swift'}
Plug 'lighttiger2505/deoplete-vim-lsp'
Plug 'machakann/vim-highlightedyank'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-grepper'
Plug 'mhinz/vim-startify'
Plug 'michaeljsmith/vim-indent-object'
Plug 'morhetz/gruvbox'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'pangloss/vim-javascript', {'for': 'javascript'}
Plug 'pedrohdz/vim-yaml-folds'
Plug 'plasticboy/vim-markdown'
Plug 'prabirshrestha/async.vim'
Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind']}
Plug 'shenbin04/deoplete-ternjs', {'for': 'javascript'}
Plug 'shenbin04/fzf', {'do': {-> fzf#install()}}
Plug 'shenbin04/fzf.vim'
Plug 'shenbin04/molokai'
Plug 'shenbin04/tern_for_vim', {'do': 'npm i', 'for': 'javascript'}
Plug 'shenbin04/vim-config-projects'
Plug 'shenbin04/vim-flow-plus'
Plug 'shenbin04/vim-lsp'
Plug 'shenbin04/vim-related'
Plug 'shenbin04/vim-snap'
Plug 'shenbin04/vim-surround'
Plug 'shenbin04/vim-test'
Plug 'shenbin04/vim-webpack', {'for': 'javascript'}
Plug 'sjl/gundo.vim'
Plug 'solarnz/thrift.vim', {'for': 'thrift'}
Plug 'svermeulen/vim-yoink'
Plug 'terryma/vim-expand-region'
Plug 'tmhedberg/SimpylFold'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary', {'on': '<Plug>Commentary'}
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails', {'for': 'ruby'}
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'ujihisa/neco-look'
Plug 'urbainvaes/vim-remembrall'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-python/python-syntax', {'for': 'python'}
Plug 'vim-ruby/vim-ruby', {'for': 'ruby'}
Plug 'vim-scripts/L9'
Plug 'vim-scripts/nginx.vim', {'for': 'nginx'}
Plug 'vimjas/vim-python-pep8-indent'
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
set diffopt+=vertical
set showmatch
set noautoread
set path+=$HOME/.vim
set completeopt-=preview
set guicursor=
set inccommand=nosplit

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
set shada=!,'2000,/500,h,\"500,:2000,n$HOME/.vim/main.shada

" Undo
set undofile
set undodir=~/.vim/undo
set undolevels=1000

" Mapping
runtime common/mapping.vim

" Autocmd
runtime common/autocmd.vim

" Terminal
runtime common/terminal.vim

" Plugin
runtime common/plugin.vim

" Local
runtime! .vimrc.local
runtime! .vimrc.project

" Color
runtime common/color.vim
