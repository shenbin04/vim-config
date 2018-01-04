" Pathogen
execute pathogen#infect()

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
set shellpipe=&>

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
set viminfo='100,/100,h,\"500,:500,n~/.vim/viminfo

" Ctags: recurse up to home to find tags
set tags+=tags;$HOME

" Mapping
let g:mapleader = ','
let g:localmapleader = ','

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

noremap <Leader>x :noh<CR>

nnoremap <Leader>s :%s/
nnoremap <Leader>S :%S/
vnoremap <Leader>s :S/

nnoremap <Leader>a :GrepperAg 
nnoremap <Leader>w yiw:GrepperAg <C-R>0

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

noremap k gk
noremap j gj
nnoremap G Gzz
nnoremap n nzz
nnoremap N Nzz
nnoremap } }zz
nnoremap { {zz
nnoremap <C-D> <C-D>zz
nnoremap <C-U> <C-U>zz
inoremap jk <ESC>

nnoremap di, f,dT,
nnoremap ci, f,cT,
nnoremap da, f,ld2F,i,<ESC>l
nnoremap ca, f,ld2F,i,<ESC>a

nnoremap tap 0f(i = <ESC>f)a =><ESC>
nnoremap taf 0/function<CR>dw/)<CR>a =><ESC>
nnoremap tae 0/function<CR>dwiconst <ESC>wwi = <ESC>/)<CR>a =><ESC>/{<CR>%a;<ESC>

onoremap if :call JSFunctionAction('')<CR>
onoremap af :call JSFunctionAction('k')<CR>
onoremap ik :call JSPropertyAction()<CR>
onoremap ic :call JSFunctionCallAction('')<CR>
onoremap ac :call JSFunctionCallAction('k')<CR>

nnoremap gj :call OpenJSFile()<CR>
nnoremap gt :call OpenTestFile()<CR>
nnoremap gc :call OpenScssFile()<CR>
nnoremap gs :call OpenSnapshotFile()<CR>

nnoremap <Leader>fb :call FormatImportBreak()<CR>
nnoremap <Leader>fj :call FormatImportJoin()<CR>
nnoremap <leader>fm V:EsformatterVisual<CR>k=a<.....
vnoremap <leader>fm :EsformatterVisual<CR>k=a<.....

nnoremap <Leader>rc :call VimuxCloseRunner()<CR>
nnoremap <Leader>ro :call VimuxOpenRunner()<CR>
nnoremap <Leader>ra :call VimuxPromptCommand()<CR>
nnoremap <Leader>rm :call VimuxZoomRunner()<CR>

nnoremap <Leader>cs :let @*=expand("%")<CR>
nnoremap <Leader>cl :let @*=expand("%:p")<CR>

" Function
function! JSFunctionAction(command)
  execute "normal! " . "?\\v^\\s*[a-zA-Z]+( \\= )\\?\\(.*\\) (\\=\\> )\\?\\{\\?\\(\\?$\<CR>f{V%o" . a:command
endfunction

function! JSPropertyAction()
  execute "normal! " . "/}\<CR>?\\v\\S+: \\{\<CR>f{V%o"
endfunction

function! JSFunctionCallAction(command)
  execute "normal! " . "?\\v^\\s+\\S+\\(\<CR>f(V%o" . a:command
endfunction

function! TryOpenFile(file, message)
  if filereadable(a:file)
    if expand('%:p') != a:file
      exe 'edit' . a:file
    endif
    return 1
  else
    " echo a:message
    return 0
  endif
endfunction

function! GetPrefix()
  let dir = split(expand('%:p:h'), '/')
  let base = join(dir[0:dir[-1] == '__snapshots__' ? -2 : -1], '/')
  return '/' . base . '/' . split(expand('%:t:r'), '\.')[0]
endfunction

function! OpenJSFile()
  let prefix = GetPrefix()
  for extension in ['.js', '.jsx']
    let file = prefix . extension
    if TryOpenFile(file, 'Cannot find javascript file ' . file)
      return
    endif
  endfor
endfunction

function! OpenTestFile()
  let prefix = GetPrefix()
  for extension in ['.js', '.jsx']
    let file = prefix . '.test' . extension
    if TryOpenFile(file, 'Cannot find test file ' . file)
      return
    endif
  endfor
endfunction

function! OpenSnapshotFile()
  for extension in ['.js', '.jsx']
    let file = expand('%:p:h') . '/__snapshots__/' . split(expand('%:t:r'), '\.')[0] . '.test' . extension . '.snap'
    if TryOpenFile(file, 'Cannot find snapshot file ' . file)
      return
    endif
  endfor
endfunction

function! OpenScssFile()
  let file = GetPrefix() . '.scss'
  call TryOpenFile(file, 'Cannot find scss file ' . file)
endfunction

function! CloseLastWindow()
  if &buftype == 'quickfix' || &buftype == 'nofile'
    if winbufnr(2) == -1
      quit!
    endif
  endif
endfunction

function! FormatImportBreak()
  exe 'normal! ^'
  call RangeJsBeautify()
  exe 'normal! f{%kA,'
endfunction

function! FormatImportJoin()
  exe 'normal! va{Jhxx%lx'
endfunction

" Autocommand
augroup vimrc
  autocmd!

  autocmd BufEnter * call CloseLastWindow()

  autocmd BufWritePost .vimrc,vimrc source $MYVIMRC

  " When opening a file, always jump to the last cursor position
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line ("'\"") <= line("$") |
      \     exe "normal! g'\"zz" |
      \ endif |

  autocmd CursorHold * silent! checktime

  autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
  autocmd InsertLeave * if pumvisible() == 0|pclose|endif

  autocmd QuickFixCmdPost * botright copen
  autocmd FileType qf wincmd J

  autocmd FileType javascript set formatprg=prettier\ --trailing-comma\ all\ --no-bracket-spacing\ --stdin
  autocmd BufRead,BufNewFile *.scss set filetype=scss.css
augroup END

" Snapshot
au BufNewFile,BufRead *.snap set filetype=snap
hi snapKeywords ctermfg=135
hi snapName ctermfg=144

" Abbreviation
iabbrev bd binding.pry;
iabbrev db import ipdb; ipdb.set_trace()
iabbrev mbr baptiste, evan, ong
iabbrev mbs phou, etai, jbotros, chung, pzalewski, yang, amarto
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
nnoremap <C-y> :YRShow<cr>
let g:yankring_max_history = 500
let g:yankring_history_dir = '$HOME/.vim'
let g:yankring_manual_clipboard_check = 0

function! YRRunAfterMaps()
  nnoremap <silent> Y :<C-U>YRYankCount 'y$'<CR>
endfunction

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
let g:ctrlp_lazy_update = 50
let g:ctrlp_mruf_exclude = '/tmp/.*\|/temp/.*\|\.git.*\|.*\/var\/folders\/.*'
let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files']

" airline
let g:airline_theme='powerlineish'
let g:airline_section_x=''
let g:airline_section_y=''
let g:airline_section_z = airline#section#create(['windowswap', '%3p%% ', 'linenr', ':%3v'])
set laststatus=2

" Nerdcommenter
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
nmap <Leader>c<Space> <Plug>NERDCommenterToggle
vmap <Leader>c<Space> <Plug>NERDCommenterToggle

" NERDTree
nnoremap <C-g> :NERDTreeToggle<cr>
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
hi ALEErrorSign ctermfg=015 ctermbg=001 cterm=none
hi ALEWarningSign ctermfg=015 ctermbg=166 cterm=none
hi link ALEError clear
hi link ALEWarning clear

nnoremap <Leader>p :ALEPreviousWrap<CR>
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

" Gundo
nnoremap <S-u> :GundoToggle<CR>
let g:gundo_close_on_revert = 1

" MiniBuf
noremap M :MBEToggle<cr>:MBEFocus<cr>
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
let g:ycm_confirm_extra_conf = 0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_global_ycm_extra_conf = '$HOME/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

" Vimux
let g:VimuxOrientation = 'h'
let g:VimuxHeight = 50
autocmd FileType javascript
      \ nnoremap <Leader>rl :call RunJestFocused()<CR>|
      \ nnoremap <Leader>rr :call RunJestOnBuffer()<CR>|
      \ nnoremap <Leader>ru :call RunJestOnBufferUpdate()<CR>|
      \ nnoremap <Leader>rw :call RunJestOnBufferWatch()<CR>

function! RunJestOnBuffer()
  call RunJest(expand('%'))
endfunction

function! RunJestOnBufferUpdate()
  call RunJest(expand('%') . ' -- -u')
endfunction

function! RunJestOnBufferWatch()
  call RunJest(expand('%') . ' -- --watch')
endfunction

function! RunJestFocused()
  execute 'normal! j'
  let test_name = JestSearchForTest('\<test(\|\<it(\|\<test.only(')

  if test_name == ''
    echoerr "Couldn't find test name to run focused test."
    return
  endif

  call RunJest(expand('%') . ' -- -t ' . test_name)
endfunction

function! JestSearchForTest(fragment)
  let line_num = search(a:fragment, 'bs')
  if line_num > 0
    return matchlist(getline(line_num), '\(''\|"\).*\(''\|"\)')[0]
  else
    return ''
  endif
endfunction

function! RunJest(test)
  call VimuxRunCommand('npm test ' . a:test)
endfunction

" Notes
nnoremap <Leader>e :MostRecentNote<CR>
