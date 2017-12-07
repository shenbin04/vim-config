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

hi Normal ctermfg=250 ctermbg=233
hi rubySymbol ctermfg=135 cterm=none
hi rubyPseudoVariable ctermfg=135 cterm=none
hi rubyException ctermfg=118 cterm=none
hi rubyConditional ctermfg=135 cterm=none
hi rubyControl ctermfg=161 cterm=none
hi rubyKeybword ctermfg=161 cterm=none
hi diffRemoved ctermfg=1 cterm=none
hi diffAdded ctermfg=2 cterm=none
hi DiffDelete ctermfg=161 ctermbg=234 cterm=italic
hi DiffAdd ctermfg=118 ctermbg=234 cterm=italic
hi DiffChange ctermfg=144 ctermbg=234 cterm=italic
hi DiffText ctermfg=2 ctermbg=234 cterm=italic
hi MatchParen ctermbg=240 ctermfg=15 cterm=none
hi ColorColumn ctermbg=234 cterm=none
hi SpellBad ctermbg=1 ctermfg=15 cterm=underline
hi LineNr ctermbg=234 ctermfg=59
hi CursorLineNr ctermbg=234 ctermfg=11
hi Comment cterm=italic
hi link jsonCommentError Comment
hi clear Error80
hi clear cssBraceError
hi clear jsonTrailingCommaError
hi clear jsParensError

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

" Undo
set undolevels=1000
set undodir=~/.vim/undo
set undofile

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

" Gitgutter
let g:gitgutter_max_signs = 1000
hi GitGutterAdd ctermfg=28 ctermbg=234 cterm=none
hi GitGutterAddLine ctermfg=28 ctermbg=234 cterm=none
hi GitGutterChange ctermfg=3 ctermbg=234 cterm=none
hi GitGutterDelete ctermfg=1 ctermbg=234 cterm=none
hi GitGutterChangeDelete ctermfg=3 ctermbg=234 cterm=none

" YankRing
nnoremap <C-y> :YRShow<cr>
let g:yankring_max_history = 200
let g:yankring_history_dir = '$HOME/.vim'
let g:yankring_manual_clipboard_check = 0

" Ctrlp
noremap <Leader>, :CtrlPMixed<CR>
let g:ctrlp_map = '<Leader>.'
let g:ctrlp_regexp = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(o|so|dll)$',
  \ }
let g:ctrlp_switch_buffer = 0
let g:ctrlp_use_caching = 0
" let g:ctrlp_lazy_update = 1
let g:ctrlp_mruf_exclude = '/tmp/.*\|/temp/.*\|\.git.*\|.*\/var\/folders\/.*'
let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files']

" airline
let g:airline_theme='powerlineish'
let g:airline_section_x=''
let g:airline_section_y=''
let g:airline_section_z = airline#section#create(['windowswap', '%3p%% ', 'linenr', ':%3v'])
set laststatus=2

" Nerdcommenter
let g:NERDSpaceDelims = 1
