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
hi Search ctermbg=11 ctermfg=0 term=reverse
hi link jsonCommentError Comment
hi clear Error80
hi clear cssBraceError
hi clear jsonTrailingCommaError
hi clear jsParensError

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
nnoremap <space> za

" Viminfo: remember certain things when we exit
set viminfo='100,/100,h,\"500,:500
if !has('nvim')
  set viminfo+=n~/.vim/viminfo
endif

" Ctags: recurse up to home to find tags
set tags+=tags;$HOME

" Mapping
let g:mapleader = ','
let g:localmapleader = ','

nnoremap _ :split<CR>
nnoremap \| :vsplit<CR>

nnoremap <Up>    2<C-w>-
nnoremap <Down>  2<C-w>+
nnoremap <Left>  2<C-w><
nnoremap <Right> 2<C-w>>

nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <Leader>J <C-w>J
nnoremap <Leader>K <C-w>K
nnoremap <Leader>H <C-w>H
nnoremap <Leader>L <C-w>L

nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>b :cclose<CR>

nnoremap <Leader>x :noh<CR>

nnoremap <Leader>s :%s/
nnoremap <Leader>S :%S/
vnoremap <Leader>s :S/
nnoremap & :&&<CR>
xnoremap & :&&<CR>

nnoremap <Leader>aa :GrepperAg 
nnoremap <Leader>aw yiw:GrepperAg "\b<C-R>0\b" 

nnoremap <Leader>1 :BufSurfBack<CR>
nnoremap <Leader>2 :BufSurfForward<CR>
nnoremap <Leader>3 :b#<CR>

nnoremap <Leader>dg :diffget<CR>
vnoremap <Leader>dg :diffget<CR>
nnoremap <Leader>dp :diffput<CR>
vnoremap <Leader>dp :diffput<CR>

vnoremap . :normal! .<CR>
vnoremap @ :normal! @

noremap <Home> :tprev<CR>
noremap <End>  :tnext<CR>
noremap <PageDown> :lnext<CR>
noremap <PageUp>   :lprev<CR>

vnoremap ss :sort<CR>
vnoremap su :sort -u<CR>

nnoremap <F2> :setlocal spell!<CR>

nnoremap <C-B> :redraw!<CR>

nnoremap <expr> k (v:count > 1 ? "m'" . v:count : '') . 'gk'
nnoremap <expr> j (v:count > 1 ? "m'" . v:count : '') . 'gj'
nnoremap <expr> gk (v:count > 1 ? "m'" . v:count : '') . 'k'
nnoremap <expr> gj (v:count > 1 ? "m'" . v:count : '') . 'j'

nnoremap G Gzz
nnoremap n nzz
nnoremap N Nzz
nnoremap } }zz
nnoremap { {zz
nnoremap <C-D> <C-D>zz
nnoremap <C-U> <C-U>zz
inoremap jk <ESC>
nnoremap gV `[v`]

nnoremap di, f,dT,
nnoremap ci, f,cT,
nnoremap da, f,ld2F,i,<ESC>l
nnoremap ca, f,ld2F,i,<ESC>a

nnoremap tap 0f(i = <ESC>f)a =><ESC>
nnoremap taf 0/function<CR>dw/)<CR>a =><ESC>
nnoremap tae 0/function<CR>dwiconst <ESC>wwi = <ESC>/)<CR>a =><ESC>/{<CR>%a;<ESC>

nnoremap <Leader>rc :call VimuxCloseRunner()<CR>
nnoremap <Leader>ro :call VimuxOpenRunner()<CR>
nnoremap <Leader>rb :call VimuxInterruptRunner()<CR>
nnoremap <Leader>ra :call VimuxPromptCommand()<CR>
nnoremap <Leader>rm :call VimuxZoomRunner()<CR>

nnoremap <Leader>cs :let @*=expand('%:t')<CR>
nnoremap <Leader>cr :let @*=util#ExpandRelative('%:p')<CR>
nnoremap <Leader>cl :let @*=expand('%:p')<CR>
nnoremap <Leader>cu :set cursorline! cursorcolumn!<CR>

nnoremap <leader>cc "*y

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

" Snapshot
au BufNewFile,BufRead *.snap set filetype=snap
hi snapKeywords ctermfg=135
hi snapName ctermfg=144

" Abbreviation
iabbrev bw baptiste, wstrasser
iabbrev gs gabe.schindler

" Undo
set undolevels=1000
set undodir=~/.vim/undo
set undofile

" Html
let html_number_lines = 1
let html_ignore_folding = 1
let html_use_css = 1
let xml_use_xhtml = 1

" Css
hi scssSelectorName ctermfg=81
hi scssVariable ctermfg=118

" Javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1
let g:jsx_ext_required = 0

" Python
let python_highlight_all = 1
let g:pymode_options_max_line_length = 120
let g:pymode_rope = 0
let g:pymode_rope_lookup_project = 0
let g:pymode_rope_complete_on_dot = 0

" Json
let g:vim_json_syntax_conceal = 0
au BufNewFile,BufRead *.eslintrc set filetype=json

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
nnoremap <C-y> :YRShow<CR>
let g:yankring_max_history = 200
let g:yankring_history_dir = '$HOME/.vim'
let g:yankring_window_height = 20

function! YRRunAfterMaps()
  nnoremap <silent> Y :<C-U>YRYankCount 'y$'<CR>
endfunction

" Ctrlp
noremap <Leader>, :CtrlPMRUFiles<CR>
noremap <Leader>. :CtrlPMixed<CR>
let g:ctrlp_map = ''
let g:ctrlp_regexp = 1
let g:ctrlp_bufpath_mod = ':~:.:h'
let g:ctrlp_match_window = 'max:25'
let g:ctrlp_reuse_window = 'netrw\|help\|quickfix'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(o|so|dll)$',
  \ }
let g:ctrlp_switch_buffer = 0
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
let g:ctrlp_lazy_update = 50
let g:ctrlp_mruf_exclude = '/tmp/.*\|/temp/.*\|\.git.*\|.*\/var\/folders\/.*'
let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files']

" airline
let g:airline_theme='powerlineish'
let g:airline_section_x=''
let g:airline_section_y=''
let g:airline_section_z = airline#section#create(['windowswap', '%3p%% ', 'linenr', ':%3v'])
set laststatus=2

" Comentary
nmap <Leader>c <Plug>Commentary
vmap <Leader>c <Plug>Commentary

" NERDTree
nnoremap <C-g> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>zz
hi NERDTreeDir ctermfg=81 cterm=none
hi NERDTreeDirSlash ctermfg=81 cterm=none
hi NERDTreeCWD ctermfg=118 cterm=none
hi NERDTreeOpenable ctermfg=59 cterm=none
hi NERDTreeClosable ctermfg=7 cterm=none
let NERDTreeQuitOnOpen = 1
let NERDTreeShowFiles = 1
let NERDTreeShowBookmarks = 1
let NERDTreeHighlightCursorline = 1
let g:NERDTreeMapJumpNextSibling = ''
let g:NERDTreeMapJumpPrevSibling = ''
let NERDTreeIgnore = [ '\.pyc$', '\.pyo$', '\.py\$class$', '\.obj$', '\.o$', '__pycache__',
                     \ '\.so$', '\.egg$', '^\.git$', '\.cmi', '\.cmo', 'tags' ]
" Rainbow
let g:rainbow_active = 1
let g:rainbow_conf = { 'ctermfgs': ['red', 'yellow', 'green', 'cyan', 'magenta', 'red', 'yellow', 'green', 'cyan', 'magenta'] }

" closetag
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.php,*.js,*.jsx'
let g:closetag_xhtml_filenames = '*.html,*.xhtml,*.phtml,*.php,*.js,*.jsx'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_close_shortcut = '<Leader>c'

" Ale
let g:ale_open_list = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_list_window_size = 1
let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '>>'
let g:ale_linters = {
\   'javascript': ['eslint', 'flow'],
\   'python': ['pylint', 'flake8'],
\}
let g:ale_javascript_eslint_options = js#ESLintArgs()
let g:ale_python_pylint_options = python#PYLintArgs()
let g:ale_python_flake8_options = '--ignore=E101,E501,W291,W292,W293'

hi ALEErrorSign ctermfg=015 ctermbg=001 cterm=none
hi ALEWarningSign ctermfg=015 ctermbg=166 cterm=none
hi link ALEError clear
hi link ALEWarning clear

nnoremap <Leader>p :ALEPreviousWrap<CR>
nnoremap <Leader>n :ALENextWrap<CR>

" EasyMotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
nmap H <Plug>(easymotion-overwin-f2)
nmap F <Plug>(easymotion-fl)
nmap T <Plug>(easymotion-tl)

" Gundo
nnoremap <Leader>u :GundoToggle<CR>
let g:gundo_close_on_revert = 1

" MiniBuf
noremap M :MBEToggle<CR>:MBEFocus<CR>
let g:MiniBufExplAutoOpen = 1
let g:miniBufExplBRSplit = 1
let g:miniBufExplBuffersNeeded = 1000
let g:miniBufExplCloseOnSelect = 1
let g:miniBufExplVSplit = 30

" Tagbar
nnoremap <Leader>t :TagbarOpen fjc<CR>

" Expand region
map K <Plug>(expand_region_expand)
map L <Plug>(expand_region_shrink)
let g:expand_region_text_objects_javascript = {
      \ 'il': 0,
      \ 'ib': 1,
      \ 'iB': 1,
      \ 'aI': 1,
      \ 'ae': 0,
      \ }

" JsBeautifier
let g:config_Beautifier = { 'js': { 'indent_size': 2 }, 'jsx': {}}

" UltiSnips
let g:UltiSnipsExpandTrigger = '<Leader>e'
let g:UltiSnipsJumpForwardTrigger = '<Leader><Tab>'

" Tabularize
noremap \= :Tabularize /=<CR>
noremap \: :Tabularize /^[^:]*:\zs/l0l1<CR>
noremap \> :Tabularize /=><CR>
noremap \, :Tabularize /,\zs/l0l1<CR>
noremap \{ :Tabularize /{<CR>
noremap \\| :Tabularize /\|<CR>
noremap \& :Tabularize /\(&\\|\\\\\)<CR>

" YCM
nnoremap <Leader>ff :YcmCompleter GoToDefinition<CR>
let g:ycm_key_invoke_completion = '<Leader><Tab>'
let g:ycm_confirm_extra_conf = 0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_global_ycm_extra_conf = '$HOME/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

" Vimux
let g:VimuxOrientation = 'h'
let g:VimuxHeight = 50

" Notes
let g:notes_directories = ['$HOME/.vim/notes']
nnoremap <Leader>e :MostRecentNote<CR>

" Vim Test
let g:test#strategy = 'vimux'
let g:test#preserve_screen = 0

nnoremap <Leader>rl :TestNearest<CR>
nnoremap <Leader>rr :TestFile<CR>

" Highlightedyank
if !exists('##TextYankPost')
  map y <Plug>(highlightedyank)
endif
let g:highlightedyank_highlight_duration = 500

" fzf
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
noremap <Leader>fa :Files<CR>
noremap <Leader>fg :GFiles<CR>
noremap <Leader>fh :History<CR>
