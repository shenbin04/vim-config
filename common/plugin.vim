" Html
let g:html_number_lines = 1
let g:html_ignore_folding = 1
let g:html_use_css = 1
let g:xml_use_xhtml = 1

" Javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1
let g:jsx_ext_required = 0

" Python
let g:python_highlight_all = 1
let g:python_host_prog = $HOME . '/.virtualenvs/vim/bin/python'
let g:python3_host_prog = $HOME . '/.virtualenvs/vim3/bin/python'

" Json
let g:vim_json_syntax_conceal = 0

" Fugitive
nnoremap <silent> <Leader>gs :10Gstatus<CR>
nnoremap <silent> <Leader>gd :call util#GitDiff('')<CR>
nnoremap <silent> <Leader>gm :call util#GitDiff('master')<CR>
nnoremap <silent> <Leader>gb :Gblame<CR>
nnoremap <silent> <Leader>grm :Gread! show master:%<CR>
nnoremap <silent> <Leader>grh :Gread! show HEAD:%<CR>
nnoremap <silent> <Leader>gap :Git add -p %<CR>
nnoremap <silent> <Leader>gcc :Gcommit -v<CR>
nnoremap <silent> <Leader>gca :Gcommit -v --amend<CR>

autocmd User fugitive
      \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
      \   nnoremap <buffer> .. :edit %:h<CR> |
      \ endif

" Gitgutter
let g:gitgutter_max_signs = 1000
nmap <Leader>gaa <Plug>GitGutterStageHunk
nmap <Leader>gp <Plug>GitGutterPreviewHunk
nmap <Leader>gu <Plug>GitGutterUndoHunk
hi GitGutterAdd ctermfg=28 ctermbg=234 cterm=none
hi GitGutterAddLine ctermfg=28 ctermbg=234 cterm=none
hi GitGutterChange ctermfg=3 ctermbg=234 cterm=none
hi GitGutterDelete ctermfg=1 ctermbg=234 cterm=none
hi GitGutterChangeDelete ctermfg=3 ctermbg=234 cterm=none

" Yoink
let g:yoinkMaxItems = 200
let g:yoinkIncludeDeleteOperations = 1
let g:yoinkSavePersistently = 1
nmap <C-p> <Plug>(YoinkPostPasteSwapBack)
nmap <C-n> <Plug>(YoinkPostPasteSwapForward)
nmap p <Plug>(YoinkPaste_p)
nmap P <Plug>(YoinkPaste_P)
nnoremap <silent> Y :normal y$<CR>
function! PutYank(line)
  let yank_history = yoink#getYankHistory()
  for item in yank_history
    if item.text ==# a:line
      call yoink#manualYank(a:line, item.type)
      normal! p
      return
    endif
  endfor
endfunction
nnoremap <silent> <Leader>zy :call fzf#run(fzf#wrap({
      \ 'source': map(filter(copy(yoink#getYankHistory()), {k, v -> !empty(trim(v.text))}), {k, v -> v.text}),
      \ 'sink': function('PutYank'),
      \ 'options': ['--prompt', 'Yank> '],
      \ }))<CR>

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#disable_refresh = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
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
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeShowFiles = 1
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeHighlightCursorline = 1
let g:NERDTreeMapJumpNextSibling = ''
let g:NERDTreeMapJumpPrevSibling = ''
let g:NERDTreeIgnore = [ '\.pyc$', '\.pyo$', '\.py\$class$', '\.obj$', '\.o$', '__pycache__',
      \ '\.so$', '\.egg$', '^\.git$', '\.cmi', '\.cmo', 'tags' ]

" Closetag
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
      \   'javascript': ['eslint', 'flow-language-server'],
      \   'python': ['pylint', 'flake8'],
      \   'css': ['stylelint'],
      \}
let g:ale_fixers = {
      \   'javascript': ['prettier'],
      \   'python': ['ALEBlack'],
      \   'css': ['prettier'],
      \   'sql': ['pgformatter'],
      \}
let g:ale_python_pylint_change_directory = 0
let g:ale_python_pylint_use_global = 1
let g:ale_python_flake8_options = '--ignore=E101,E501,W291,W292,W293,W503'
let g:ale_sql_pgformatter_options = '%s'

function! ALEBlack(buffer, lines)
  Black
endfunction

hi ALEErrorSign ctermfg=015 ctermbg=001 cterm=none
hi ALEWarningSign ctermfg=015 ctermbg=166 cterm=none
hi link ALEError clear
hi link ALEWarning clear

nmap <Leader>fa <Plug>(ale_fix)
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

" Tagbar
let g:tagbar_left = 1
let g:tagbar_width = 30
nnoremap <C-t> :TagbarOpenAutoClose<CR>

" Expand Region
map K <Plug>(expand_region_expand)
map L <Plug>(expand_region_shrink)
let g:expand_region_text_objects_javascript = {
      \ 'il': 0,
      \ 'ib': 1,
      \ 'iB': 1,
      \ 'aI': 1,
      \ 'ae': 0,
      \ }

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

" Deoplete
let g:deoplete#enable_at_startup = 1
inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<tab>"

call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])

" deoplete-ternjs
let g:deoplete#sources#ternjs#types = 1

" deoplete-vim-lsp
let g:lsp_diagnostics_enabled = 0
let g:lsp_highlight_references_enabled = 1
highlight lspReference ctermbg=11 ctermfg=0
call deoplete#custom#source('lsp', {'rank': 999, 'min_pattern_length': 0})

nnoremap <silent> <Leader>ff :LspDefinition<CR>
nnoremap <silent> <Leader>fp :LspHover<CR>

if executable('flow')
  autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'flow',
        \ 'cmd': {server_info->['flow', 'lsp', '--from', 'vim-lsp']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.flowconfig'))},
        \ 'whitelist': ['javascript', 'javascript.jsx'],
        \ })
else
  echohl ErrorMsg
  echom '`flow` not found.'
  echohl NONE
endif

if executable('typescript-language-server')
  autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'typescript support using typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
        \ 'whitelist': ['typescript', 'typescript.tsx', 'typescriptreact'],
        \ })
else
  echohl ErrorMsg
  echom '`typescript-language-server` not found.'
  echohl NONE
endif

if executable('pyls')
  autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
else
  echohl ErrorMsg
  echom '`pyls` not found.'
  echohl NONE
endif

" Tern
let g:tern#command = [$HOME . '/.vim/bundle/tern_for_vim/node_modules/.bin/tern']
let g:tern#arguments = ['--persistent']
let g:tern_show_signature_in_pum = 1
let g:tern_request_timeout = 10

" Notes
let g:notes_directories = ['$HOME/.vim/notes']
nnoremap <Leader>er :RecentNote<CR>
nnoremap <Leader>en :MostRecentNote<CR>
hi notesName ctermfg=81 cterm=underline

" Vim Test
let g:test#strategy = 'neoterm'
let g:test#preserve_screen = 0
nnoremap <silent> <Leader>rl :call util#Topen()<CR>:TestNearest<CR>
nnoremap <silent> <Leader>rr :call util#Topen()<CR>:TestFile<CR>

" Highlightedyank
if !exists('##TextYankPost')
  map y <Plug>(highlightedyank)
endif
let g:highlightedyank_highlight_duration = 500

" FZF
let g:fzf_history_dir = '~/.fzf-history'
let g:fzf_layout = {'down': '16'}
let g:fzf_ignore = ['\v(\.git/|term:)']
let g:fzf_colors = {
      \ 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Type'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Title'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'],
      \ }

command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=? -complete=dir GitFiles call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=? -complete=dir GFiles call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=? -complete=dir Mixed call fzf#vim#mixed(<q-args>, fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=+ -complete=dir Ag call util#ag(<q-args>, <bang>0)

nnoremap <Leader>aa :<C-R>=util#get_search_cmd()<CR> 

noremap <Leader>, :cclose<CR>:call util#CloseFugitive()<CR>:History<CR>
noremap <Leader>. :Mixed<CR>
noremap <Leader>za :Files<CR>
noremap <Leader>zgb :BCommits<CR>
noremap <Leader>zgc :Commits<CR>
noremap <Leader>zm :Maps<CR>
noremap <Leader>zz :GFiles?<CR>
noremap <Leader>zc :History:<CR>
noremap <silent> <Leader>zb :call fzf#run({'source': 'git --no-pager branch --format "%(refname:short)"', 'sink': '!git checkout'})<CR>

" Unimpaired
let g:nremap = {"[t": "", "]t": ""}
let g:xremap = {"[t": "", "]t": ""}
let g:oremap = {"[t": "", "]t": ""}

" Ag
let g:ag_no_test = ' -G "(?<!test)\.(jsx?|py|m|swift|h|html|ts)$"'
nnoremap <Leader>aw "wyiw:<C-R>=util#get_search_cmd()<CR> '\b<C-R>w\b' 
nnoremap <Leader>anw "wyiw:<C-R>=util#get_search_cmd()<CR> '<C-R>w' 
nnoremap <Leader>asw "wyiw:<C-R>=util#get_search_cmd()<CR> <C-R>=g:ag_no_test<CR> '\b<C-R>w\b' 
nnoremap <Leader>asnw "wyiw:<C-R>=util#get_search_cmd()<CR> <C-R>=g:ag_no_test<CR> '<C-R>w' 
nnoremap <Leader>aW "wyiW:<C-R>=util#get_search_cmd()<CR> '\b<C-R>w\b' 
nnoremap <Leader>anW "wyiW:<C-R>=util#get_search_cmd()<CR> '<C-R>w' 
nnoremap <Leader>ag "wyiw:<C-R>=util#get_search_cmd()<CR> '(message\|rpc\|enum) \b<C-R>w\b' protobuf/<CR>
nnoremap <Leader>at :let g:grepper.jump = 1<CR>:let g:grepper.switch = 0<CR>"wyiw:GrepperAg '(^\s+\b<C-R>w\b\|^(struct\|enum) \b<C-R>w\b\|\b<C-R>w\(\|^\s+\d+: .*\b<C-R>w\b(\s+// .+)?$)' thrift/<CR>:let g:grepper.jump = 0<CR>:let g:grepper.switch = 1<CR>zz
vnoremap <Leader>aa "wy:<C-R>=util#get_search_cmd()<CR> '\b<C-R>w\b' 
nnoremap <Leader>av :<C-R>=util#get_search_cmd()<CR> ~/.vim/<S-Left><Left> 

nnoremap <Leader>ap "wyiw:call util#GrepByWord(1, util#FindProject() . g:ag_no_test)<CR>
nnoremap <Leader>asp "wyiw:call util#GrepByWord(1, util#FindProject())<CR>
nnoremap <Leader>awp "wyiw:call util#GrepByWord(0, util#FindProject() . g:ag_no_test)<CR>
nnoremap <Leader>aswp "wyiw:call util#GrepByWord(0, util#FindProject())<CR>
vnoremap <Leader>ap "wy:call util#GrepByWord(1, util#FindProject() . g:ag_no_test)<CR>
vnoremap <Leader>asp "wy:call util#GrepByWord(1, util#FindProject())<CR>
vnoremap <Leader>awp "wy:call util#GrepByWord(0, util#FindProject() . g:ag_no_test)<CR>
vnoremap <Leader>aswp "wy:call util#GrepByWord(0, util#FindProject())<CR>

" HLT
nmap <Leader>_ <Plug>HiLinkTrace

" QFEnter
let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_keymap.topen = ['<C-t>']

" Flow
let g:flow#flowpath = util#ExpandToGit(getcwd()) . '/node_modules/.bin/flow'

" Marvim
let g:marvim_store = $HOME.'/.vim/macro'
let g:marvim_find_key = '<Leader>mf'
let g:marvim_store_key = '<Leader>ms'
noremap <Leader>me :execute 'e ' . g:marvim_store<CR>

" Live Markdown
nnoremap <Leader>md :LivedownToggle<CR>

" Neoterm
let g:neoterm_default_mod = 'vertical botright'
let g:neoterm_autoscroll = 1
let g:neoterm_fixedsize = 1
command! -nargs=1 NeotermSendKey :call neoterm#exec({ 'cmd': [<q-args>]})
nnoremap <Leader>t. :NeotermSendKey 
nnoremap <Leader>tt :Topen \| T 
nnoremap <silent> <Leader>` :Ttoggle<CR>
nnoremap <silent> <Leader>rb :Tkill<CR>
nnoremap <silent> <Leader>rc :Tclose!<CR>

" GV
nnoremap <silent> <Leader>gla :GV<CR>
nnoremap <silent> <Leader>glc :GV -- <C-R>=expand('%:h')<CR><CR>
nnoremap <silent> <Leader>gll :GV!<CR>

" Slash
noremap <plug>(slash-after) zz

" Peekaboo
let g:peekaboo_window = 'vertical botright 50new'

" Remembrall
nnoremap <silent> <expr> <Leader>r Remembrall(',r')
nnoremap <silent> <expr> <Leader>f Remembrall(',f')
nnoremap <silent> <expr> <Leader>a Remembrall(',a')

" Black
let g:black_linelength = 120
let g:black_fast = 1
let g:black_skip_string_normalization = 1

" Startify
let g:startify_change_to_dir = 0
let g:startify_custom_header = []
let g:startify_files_number = 20
let g:startify_lists = [
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]
