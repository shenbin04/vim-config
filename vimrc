" Pathogen
execute pathogen#infect()

" General
syntax on
set number
set relativenumber
set hidden
set cursorline
set cursorcolumn
set backspace=eol,start,indent
set updatecount=100
set directory=~/.vim/swap
set diffopt=filler,iwhite
set history=1000
set scrolloff=3
set visualbell t_vb=
set shortmess+=A
set foldlevelstart=99
set pastetoggle=<F1>
set ttimeoutlen=0
set updatetime=1000
set shellpipe=&>
set encoding=utf-8
set rtp+=/usr/local/opt/fzf

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
set showmatch

" Fold
set foldmethod=indent

" Viminfo: remember certain things when we exit
set viminfo='100,/100,h,\"500,:500
if !has('nvim')
  set viminfo+=n~/.vim/viminfo
endif

" Ctags: recurse up to home to find tags
set tags+=tags;$HOME

" Color
runtime! common/color.vim

" Mapping
runtime! common/mapping.vim

" Plugin
runtime! common/plugin.vim

" Function
function! CloseLastWindow()
  if &buftype == 'quickfix' || &buftype == 'nofile'
    if winbufnr(2) == -1
      quit!
    endif
  endif
endfunction

" Autocommand
augroup vimrc
  autocmd!

  autocmd BufEnter * call CloseLastWindow()

  autocmd BufWritePost .vimrc,vimrc source $MYVIMRC

  if has('nvim')
    autocmd TermOpen * startinsert
  endif

  " When opening a file, always jump to the last cursor position
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line ("'\"") <= line("$") |
      \     exe "normal! g'\"zz" |
      \ endif |

  autocmd CursorHold * silent! checktime

  autocmd QuickFixCmdPost * botright copen
  autocmd FileType qf wincmd J

  autocmd BufRead,BufNewFile *.scss set filetype=scss.css
  autocmd BufRead,BufNewFile *.aurora set filetype=python
augroup END

" Abbreviation
iabbrev bw baptiste, wstrasser
iabbrev gs gabe.schindler

" Undo
set undolevels=1000
set undodir=~/.vim/undo
set undofile
