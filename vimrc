" Pathogen
execute pathogen#infect()

" Auto reload vimrc
autocmd BufWritePost .vimrc,vimrc source $MYVIMRC

" General
syntax on
set number
set relativenumber
set hidden
set cursorline
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

" Html
let html_number_lines = 1
let html_ignore_folding = 1
let html_use_css = 1
let xml_use_xhtml = 1

" Javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1
let g:jsx_ext_required = 0
hi link jsClassProperty jsClassFuncName
hi link jsObjectKey Identifier
hi link jsImport jsClassKeyword
hi link jsFrom jsClassKeyword
hi link jsExport jsClassKeyword
hi link jsExtendsKeyword jsClassKeyword
hi link jsObjectKeyComputed jsGlobalObjects
hi link jsFlowObject Identifier
hi link jsFlowGroup Identifier
hi link jsFlowTypeStatement jsGlobalObjects
hi link jsFlowTypeValue jsGlobalObjects
hi link jsFlowTypeof jsClassKeyword
hi link jsFlowImportType jsGlobalObjects
hi jsThis ctermfg=81
hi jsFuncCall ctermfg=81
hi jsFuncName ctermfg=118
hi jsClassDefinition ctermfg=81
hi jsTemplateBraces ctermfg=81

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

" NERDTree
nnoremap <C-g> :NERDTreeToggle<cr>
nnoremap <C-f> :NERDTreeFind<CR>zz
hi NERDTreeDir ctermfg=81 cterm=none
hi NERDTreeDirSlash ctermfg=81 cterm=none
hi NERDTreeCWD ctermfg=118 cterm=none
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

" losetag
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.php,*.js,*.jsx"
let g:closetag_xhtml_filenames = "*.html,*.xhtml,*.phtml,*.php,*.js,*.jsx"
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_close_shortcut = '<Leader>c'

" Ale
let g:ale_open_list = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_list_window_size = 1
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '>>'
hi ALEErrorSign ctermfg=015 ctermbg=001 cterm=none
hi ALEWarningSign ctermfg=015 ctermbg=166 cterm=none
hi link ALEError clear
hi link ALEWarning clear

nnoremap <Leader>n :ALENextWrap<CR>

function! PYLintArgs()
  let config = findfile('.arc/.pylintrc', '.;')
  return config != '' ? '--rcfile ' . shellescape(fnamemodify(config, ':p')) : ''
endfunction

function! ESLintArgs()
  let rules = finddir('.arc/linters/eslint_rules', '.;')
  return rules != '' ? '--rulesdir ' . shellescape(fnamemodify(rules, ':p:h')) : ''
endfunction

autocmd FileType javascript let b:ale_javascript_eslint_options = ESLintArgs()
autocmd FileType python let b:ale_python_pylint_options = PYLintArgs() |
            \ let b:ale_python_flake8_options = '--ignore=E101,E501,W291,W292,W293'

" EasyMotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
nmap H <Plug>(easymotion-overwin-f2)
