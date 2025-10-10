" Html
let g:html_number_lines = 1
let g:html_ignore_folding = 1
let g:html_use_css = 1
let g:xml_use_xhtml = 1

" Javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1
let g:vim_jsx_pretty_colorful_config = 1
let g:vim_jsx_pretty_highlight_close_tag = 1

" Python
let g:python_highlight_all = 1
let g:python_host_prog = $HOME . '/.virtualenvs/vim/bin/python'
let g:python3_host_prog = $HOME . '/.virtualenvs/vim3/bin/python'

" Json
let g:vim_json_syntax_conceal = 0

" Fugitive
nnoremap <silent> <Leader>gs :call util#OpenFugitive()\|0Git<CR>
nnoremap <silent> <Leader>gd :call util#GitDiff('')<CR>
nnoremap <silent> <Leader>gm :call util#GitDiff('master')<CR>
nnoremap <silent> <Leader>gb :Git blame<CR>
nnoremap <silent> <Leader>grm :Gread! show master:%<CR>
nnoremap <silent> <Leader>grh :Gread! show HEAD:%<CR>
nnoremap <silent> <Leader>gaa :tab Git add -p<CR>
nnoremap <silent> <Leader>gaf :tab Git add %<CR>
nnoremap <silent> <Leader>gap :tab Git add -p %<CR>
nnoremap <silent> <Leader>gcc :tab Git commit -v<CR>
nnoremap <silent> <Leader>gca :tab Git commit -v --amend<CR>

autocmd User fugitive
      \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
      \   nnoremap <buffer> .. :edit %:h<CR> |
      \ endif

" Gitgutter
let g:gitgutter_max_signs = 1000
nmap <Leader>gah <Plug>GitGutterStageHunk
nmap <Leader>gp <Plug>GitGutterPreviewHunk
nmap <Leader>gu <Plug>GitGutterUndoHunk

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
let g:airline_theme='base16'
let g:airline_section_x=''
let g:airline_section_y=''
let g:airline_section_z = airline#section#create(['windowswap', '%3p%% ', 'linenr', ':%3v'])
set laststatus=2

" Comentary
nmap <Leader>c <Plug>Commentary
xmap <Leader>c <Plug>Commentary
omap <Leader>c <Plug>Commentary

" NERDTree
nnoremap <C-g> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>zz
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeShowFiles = 1
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeHighlightCursorline = 1
let g:NERDTreeMapJumpNextSibling = ''
let g:NERDTreeMapJumpPrevSibling = ''
let g:NERDTreeIgnore = [ '\.pyc$', '\.pyo$', '\.py\$class$', '\.obj$', '\.o$', '__pycache__',
      \ '\.so$', '\.egg$', '^\.git$', '\.cmi', '\.cmo', '^tags$' ]

" Closetag
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.php,*.js,*.jsx,*.ts,*.tsx'
let g:closetag_xhtml_filenames = '*.html,*.xhtml,*.phtml,*.php,*.js,*.jsx,*.ts,*.tsx'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_close_shortcut = '<Leader>c'

" Ale
let g:ale_set_loclist = 1
let g:ale_list_window_size = 1
let g:ale_lint_on_enter = 0
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '>>'
let g:ale_linters = {
      \   'javascript': ['eslint', 'flow-language-server'],
      \   'python': ['pylint', 'flake8'],
      \   'css': ['stylelint'],
      \}
let g:ale_fixers = {
      \   'python': ['isort', 'black'],
      \   'javascript': ['prettier'],
      \   'typescript': ['prettier'],
      \   'typescriptreact': ['prettier'],
      \   'css': ['prettier'],
      \   'json': ['prettier'],
      \   'jsonc': ['prettier'],
      \   'html': ['prettier'],
      \   'sql': ['pgformatter'],
      \}
let g:ale_python_pylint_change_directory = 0
let g:ale_python_pylint_use_global = 1
let g:ale_python_black_options = '--line-length 120'
let g:ale_python_flake8_options = '--ignore=E101,E501,W291,W292,W293,W503'
let g:ale_sql_pgformatter_options = '%s'
let g:ale_yaml_yamllint_options = '-d "{extends: relaxed}"'

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

call deoplete#custom#source('_', {'matchers': ['matcher_full_fuzzy']})
call deoplete#custom#source('look', {'min_pattern_length': 5})
call deoplete#custom#source('emoji', {'filetypes': []})

call deoplete#custom#var('buffer', {'require_same_filetype': 0})

call deoplete#custom#option('auto_complete_delay', 100)
call deoplete#custom#option('ignore_sources', {'css': ['look']})
call deoplete#custom#option('keyword_patterns', {'javascript': '[a-zA-Z_@.-]\k*'})

" deoplete-emoji
function! ToggleDeopleteEmojiConverter()
  call deoplete#custom#source('emoji', 'converters', [g:deoplete#sources#emoji#converter])
endfunction

" deoplete-ternjs
let g:deoplete#sources#ternjs#case_insensitive = 1
let g:deoplete#sources#ternjs#depths = 1
let g:deoplete#sources#ternjs#docs = 1
let g:deoplete#sources#ternjs#filter = 0
let g:deoplete#sources#ternjs#timeout = 10
let g:deoplete#sources#ternjs#types = 1
call deoplete#custom#source('tern', {'rank': 50})

" deoplete-vim-lsp
let g:lsp_diagnostics_enabled = 0
let g:lsp_highlight_references_enabled = 1
highlight lspReference ctermbg=11 ctermfg=0
call deoplete#custom#source('lsp', {'rank': 999, 'min_pattern_length': 0})

nnoremap <silent> <Leader>ff :LspDefinition<CR>
nnoremap <silent> <Leader>fp :LspHover<CR>
nnoremap <silent> <Leader>fr :LspRename<CR>
nnoremap <silent> <Leader>fu :LspReferences<CR>

if executable('flow')
  autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'flow',
        \ 'cmd': {server_info->['flow', 'lsp', '--from', 'vim-lsp']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.flowconfig'))},
        \ 'whitelist': ['javascript', 'javascript.jsx'],
        \ })
else
  call util#EchoError('`flow` not found.')
endif

if executable('typescript-language-server')
  autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'typescript support using typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
        \ 'whitelist': ['typescript', 'typescript.tsx', 'typescriptreact'],
        \ })
else
  call util#EchoError('`typescript-language-server` not found.')
endif

if executable('pyright-langserver')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'pyright',
        \ 'cmd': {server_info->['pyright-langserver', '--stdio']},
        \ 'whitelist': ['python'],
        \ 'workspace_config': {server_info->{}},
        \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), ['pyproject.toml', 'setup.py', 'requirements.txt', '.git']))}
        \ })
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

" Vim Test
let g:test#strategy = 'neoterm'
let g:test#preserve_screen = 1
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

command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(g:fzf_preview_window), <bang>0)
command! -bang -nargs=? -complete=dir GitFiles call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(g:fzf_preview_window), <bang>0)
command! -bang -nargs=? -complete=dir GFiles call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(g:fzf_preview_window), <bang>0)
command! -bang -nargs=? -complete=dir Mixed call fzf#vim#mixed(<q-args>, fzf#vim#with_preview(g:fzf_preview_window), <bang>0)
command! -bang -nargs=? -complete=dir History call s:history(<q-args>, <bang>0)
command! -bang -nargs=* -complete=dir Ag call util#ag(<q-args>, <bang>0)

function! s:history(arg, bang)
  let bang = a:bang || a:arg[len(a:arg)-1] == '!'
  if a:arg[0] == ':'
    call fzf#vim#command_history(bang)
  elseif a:arg[0] == '/'
    call fzf#vim#search_history(bang)
  else
    call fzf#vim#history(fzf#vim#with_preview(g:fzf_preview_window), bang)
  endif
endfunction

nnoremap <Leader>aa :<C-R>=util#GetSearchCmd()<CR> 

let g:toggle_flags = [
      \ {'name': 'g:search#use_fzf', 'default': 1, 'value': 0},
      \ {'name': 'g:test#javascript#jest#cache', 'default': 1, 'value': 0},
      \ {'name': 'g:fzf_preview_window', 'default': 'right', 'value': 'up', 'use_default': winwidth(0) > winheight(0) * 4 },
      \ {'name': 'g:neoterm_default_mod', 'default': 'vertical botright', 'value': 'botright', 'use_default': util#IsWideWin() },
      \ {'name': 'g:test#javascript#jest#project_coverage', 'default': 0, 'value': 1},
      \ {'name': 'g:test#python#pants', 'default': 0, 'value': 1},
      \ {'name': 'g:deoplete#sources#emoji#converter', 'default': '', 'value': 'converter_emoji', 'callback': function('ToggleDeopleteEmojiConverter')},
      \]

for index in range(len(g:toggle_flags))
  let flag = g:toggle_flags[index]
  if !exists(flag.name)
    execute 'let ' . flag.name . ' = ' . string(get(flag, 'use_default', 1) ? flag.default : flag.value)
  endif
  execute 'noremap <Leader>z' . (index + 1) . ' :call util#ToggleFlag(g:toggle_flags[' . string(index) . '])<CR>'
endfor

function! ToggleFlag(line)
  for flag in g:toggle_flags
    if flag.name ==# split(a:line, ' = ')[0]
      call util#ToggleFlag(flag)
      return
    endif
  endfor
endfunction

nnoremap <silent> <Leader>zt :call fzf#run(fzf#wrap({
      \ 'source': map(copy(g:toggle_flags), {_, val -> val.name . ' = ' . string(get(g:, val.name[2:]))}),
      \ 'sink': function('ToggleFlag'),
      \ 'options': ['--prompt', 'Toggle Flag> '],
      \ }))<CR>

noremap <Leader>, :History!<CR>
noremap <Leader>. :Mixed!<CR>
noremap <Leader>za :Files!<CR>
noremap <Leader>ze :Snippets!<CR>
noremap <Leader>zgb :BCommits!<CR>
noremap <Leader>zgc :Commits!<CR>
noremap <Leader>zm :Maps!<CR>
noremap <Leader>zz :GFiles?<CR>
noremap <Leader>zc :History:!<CR>
noremap <silent> <Leader>zb :call fzf#run({'source': 'git --no-pager branch --format "%(refname:short)"', 'sink': '!git checkout'})<CR>

" Unimpaired
let g:nremap = {"[t": "", "]t": ""}
let g:xremap = {"[t": "", "]t": ""}
let g:oremap = {"[t": "", "]t": ""}

" Ag
let g:ag_no_test = ' -G "(?<!test)\.\w+(?<!.snap)$"'
nnoremap <silent> <Leader>ag :call GrepperFindProtobuf('protobuf')<CR>
nnoremap <silent> <Leader>at :call GrepperFindThrift('thrift')<CR><CR>

nnoremap <Leader>aw :<C-R>=util#GetSearchCmd()<CR> '\b<C-R>=expand('<cword>')<CR>\b' 
nnoremap <Leader>asw :<C-R>=util#GetSearchCmd()<CR> '\b<C-R>=expand('<cword>')<CR>\b' <C-R>=g:ag_no_test<CR> 
nnoremap <Leader>av :<C-R>=util#GetSearchCmd()<CR> ~/.vim/<S-Left><Left> 
nnoremap <Leader>ac :<C-R>=util#GetSearchCmd()<CR> <C-R>=expand('<cword>')<CR> 

nnoremap <Leader>ap :call util#GrepByWord(1, util#FindProject() . g:ag_no_test)<CR>
nnoremap <Leader>asp :call util#GrepByWord(1, util#FindProject())<CR>

vnoremap <Leader>aa "zy:<C-R>=util#GetSearchCmd()<CR> '\b<C-R>=escape(@z, '!#%')<CR>\b' 
vnoremap <Leader>ap "zy:<C-R>=util#GetSearchCmd()<CR> '\b<C-R>=escape(@z, '!#%')<CR>\b' <C-R>=util#FindProject() . g:ag_no_test<CR><CR>
vnoremap <Leader>asp "zy:<C-R>=util#GetSearchCmd()<CR> '\b<C-R>=escape(@z, '!#%')<CR>\b' <C-R>=util#FindProject()<CR><CR>

function! GrepperFindThrift(dir)
  let word = expand('<cword>')
  let cmd = "normal! :Ag "
        \ . shellescape('('
        \   . '^\s+\b' . word . '\b'
        \   . '|^(struct|enum) \b' . word . '\b'
        \   . '|\b' . word . '\b\('
        \   . '|^\s+\d+: .*\b' . word . '\b( +// .+)?$'
        \   . ')')
        \ . ' ' . a:dir . "\<CR>"
  silent execute cmd
endfunction

function! GrepperFindProtobuf(dir)
  let word = expand('<cword>')
  let cmd = "normal! :Ag "
        \ . shellescape('('
        \   . '(message|rpc|enum) \b' . word . '\b'
        \   . '|\b' . word . '\b = '
        \   . ')')
        \ . ' ' . a:dir . "\<CR>"
  silent execute cmd
endfunction

" HLT
nmap <Leader>_ <Plug>HiLinkTrace

" QFEnter
let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_keymap.topen = ['<C-t>']

" Marvim
let g:marvim_dir = $HOME.'/.marvim/'
let g:marvim_find_key = '<Leader>mf'
let g:marvim_store_key = '<Leader>ms'
noremap <Leader>me :execute 'e ' . g:marvim_dir<CR>

" Markdown
let g:mkdp_auto_close = 0
nmap <Leader>md <Plug>MarkdownPreviewToggle

" Neoterm
let g:neoterm_autoscroll = 1
let g:neoterm_fixedsize = 1
command! -nargs=1 NeotermSendKey :call neoterm#exec({ 'cmd': [<q-args>]})
nnoremap <Leader>t. :NeotermSendKey 
nnoremap <Leader>tt :Topen \| T 
nnoremap <silent> <Leader>tr :call util#NeotermResize()<CR>
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

" Buffer History
nmap <Leader>1 <Plug>(buffer-history-back)
nmap <Leader>2 <Plug>(buffer-history-forward)
nmap <Leader>0 <Plug>(buffer-history-list)

" EasyAlign
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" TableMode
let g:table_mode_disable_tableize_mappings = 1

" EchoDoc
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'floating'
