function! AfterVimOpen(...)
  YRCheckClipboard
endfunction

function! util#AfterVimOpen()
  if has('timers')
    call timer_start(0, 'AfterVimOpen')
  else
    call s:AfterVimOpen()
  endif
endfunction

function! util#TryOpenFile(file)
  if filereadable(a:file)
    if util#ExpandRelative('%:p') != a:file
      exe 'edit ' . a:file
    endif
    return 1
  else
    return 0
  endif
endfunction

function! util#GetBaseFileName()
  return split(expand('%:t:r'), '\.')[0]
endfunction

function! util#ExpandRelative(pattern)
  return fnamemodify(expand(a:pattern), ':.')
endfunction

function! util#ExpandToGit(from)
  return fnamemodify(finddir('.git', a:from . ';'), ':h')
endfunction

function! util#ExpandRelativeToGit(pattern)
  return xolox#misc#path#relative(expand(a:pattern), fnamemodify(util#ExpandToGit('.'), ':p'))
endfunction

function! util#CloseLastWindow()
  if &buftype == 'quickfix'
    if winbufnr(2) == -1
      quit!
    endif
  endif
endfunction

function! util#Zoom()
  if winnr('$') == 1 && len(gettabinfo()) > 1
    q
  elseif winnr('$') > 1
    tab split
  endif
endfunction

function! util#SaveView()
  if expand('%') != '' && &buftype != 'terminal' && &buftype != 'nofile'
    mkview
  endif
endfunction

function! util#LoadView()
  if expand('%') != '' && &buftype != 'terminal' && &buftype != 'nofile'
    silent! loadview
  endif
endfunction

function! util#SelectBetweenPattern(pattern)
  let line = getline('.')
  if line !~ a:pattern
    let start = search(a:pattern, 'bW')
    if !start
      return
    end
  endif
  let current = line('.')
  let next = search(a:pattern, 'W')
  if next > current
    let end = next - 1
  elseif next == 0
    let end = line('$')
  else
    let end = current
  endif
  execute "normal! " . current . "GV" . end . "G"
endfunction

function! util#SetReg(reg, message)
  execute 'let @' . a:reg . '="' . a:message . '"'
  echo 'Copied: ' . a:message
endfunction

function! util#MaybeInsertMode()
  if &buftype == 'terminal'
    startinsert
  endif
endfunction

function! util#OpenHtml() range
  let g:html_use_css = 0
  let g:html_number_lines = 0
  execute a:firstline . ',' a:lastline . 'TOhtml'
  unlet g:html_number_lines
  execute 'sav ' . xolox#misc#path#tempdir() . '/' . expand('%:t')
  silent !open %:p
  bd!
endfunction

function! util#OpenStash() range
  if !exists('g:stash_url')
    echo 'Please set g:stash_url first'
    return
  endif
  let top = a:firstline
  let bot = a:lastline
  let path = g:stash_url . util#ExpandRelativeToGit('%:p') . '\#' . top
  if bot > top
    let path = path . '-' . bot
  endif
  let @+ = xolox#misc#str#unescape(path)
  silent execute '!open ' . path
endfunction

function! util#OpenDiffusion() range abort
  if !exists('g:diffusion_url')
    echo 'Please set g:diffusion_url first'
    return
  endif
  let top = a:firstline
  let bot = a:lastline

  let path = g:diffusion_url . util#ExpandRelativeToGit('%:p')

  let branch = system('git rev-parse --abbrev-ref HEAD')[0:-2]
  if branch == 'master'
    let hash = system('git rev-parse --verify HEAD')[0:-2]
    let path = path . '\;' . hash
  endif

  let path = path . '\$' . top
  if bot > top
    let path = path . '-' . bot
  endif

  let @+ = xolox#misc#str#unescape(path)
  silent execute '!open ' . path
endfunction

function! util#yapfOperator(type, ...)
  if a:type ==# 'line'
    let line_start = getpos("'[")[1]
    let line_end = getpos("']")[1]
    silent execute line_start . ',' . line_end . 'call yapf#YAPF()'
  endif
endfunction

function! util#prettierOperator(type, ...)
  if a:type ==# 'line' || a:type ==# 'char'
    let line_start = getpos("'[")[1]
    let line_end = getpos("']")[1]
    echo [line_start, line_end]
    execute line_start . ',' . line_end . 'call prettier#Prettier()'
  endif
endfunction

function! util#GetCharOffset(line)
  return len(join(getline(0, a:line)[:-2], ' '))
endfunction

function! util#ClearHighlight()
  if exists('g:plugs["jedi-vim"]')
    call jedi#remove_usages()
  endif
endfunction

function! util#GitDiff(target)
  if expand('%') ==# ''
    return
  endif
  execute 'Gdiff ' . a:target
  call s:diff_window_syntax('diff')
endfunction

function! util#GitDiffEnd()
  if s:get_diff_window_count() == 2
    call s:diff_window_syntax('on')
  endif
endfunction

function! util#CloseFugitive()
  if buflisted(bufname('.git/index'))
    bd .git/index
  endif
endfunction

function! util#CloseDiff()
  let diff_buffers = s:get_diff_buffers()
  for bufnr in diff_buffers
    execute 'bd' . bufnr
  endfor
endfunction

function! s:diff_window_syntax(syntax) abort
  for nr in range(1, winnr('$'))
    if getwinvar(nr, '&diff')
      call setbufvar(winbufnr(nr), '&syntax', a:syntax)
    endif
  endfor
endfunction

function! s:get_diff_buffers() abort
  let diff_buffers = []
  for nr in range(1, winnr('$'))
    if getwinvar(nr, '&diff')
      call add(diff_buffers, winbufnr(nr))
    endif
  endfor
  return diff_buffers
endfunction

function! s:get_diff_window_count() abort
  return len(s:get_diff_buffers())
endfunction

function! util#get_neoterm_window() abort
  for nr in range(1, winnr('$'))
    if getwinvar(nr, '&filetype') ==# 'neoterm'
      return win_getid(nr)
    endif
  endfor
endfunction

function! util#toggle_flag(flag, default) abort
  if !exists(a:flag)
    execute 'let ' . a:flag . ' = ' . a:default
  endif
  execute 'let ' . a:flag . ' = !' . a:flag
  execute 'echo "[toggle_flag] ' . a:flag . ' = " . ' . a:flag
endfunction

function! util#get_search_cmd() abort
  if !exists('g:search#use_fzf')
    return 'Ag!'
  endif
  return g:search#use_fzf ? 'Ag!' : 'GrepperAg'
endfunction

function! util#GrepByWord(by_word, path)
  let boundary = a:by_word ? "\\b" : ""
  let cmd = util#get_search_cmd() . " \"" . boundary . @w . boundary . "\" " . a:path
  execute "normal! :" . cmd . "\<CR>"
  call histadd('cmd', cmd)
endfunction

function! util#ag(args, bang)
  let args = split(a:args)

  if empty(args)
    return
  endif

  let dir = ''

  let i = 1
  if len(args) >= 2
    while i < len(args) - 1 && args[i + 1][0] != '-'
      let i = i + 1
    endwhile
    let dir = args[i]
  endif

  let options = {}
  if !empty(dir)
    let options.dir = dir
    let options.options = '--prompt Ag[' . dir . ']'
    unlet args[i]
  endif

  call fzf#vim#ag_raw(join(args), fzf#vim#with_preview(options), a:bang)
endfunction

function! util#Topen()
  call util#CloseDiff()
  Topen
endfunction

function! util#OpenOwnersFile()
  let file = findfile('OWNERS', '.;')
  call util#TryOpenFile(file)
endfunction

function! util#FindProject()
  for file in ['.project', '.flowconfig', 'webpack.config.js', 'jest.config.js']
    let path = findfile(file, '.;')
    if len(path)
      return fnamemodify(path, ':~:.:h')
    endif
  endfor
  return ''
endfunction

function! util#EditProject()
  execute 'Files ' . util#FindProject()
endfunction

function! util#SendKeys(cmd)
  call neoterm#exec({'cmd': [a:cmd]})
endfunction

function! util#GenAll()
  call python#GenThrift()
  call python#GenProtobuf()
  call js#GenProtobuf()
endfunction

function! util#RenameFile()
  let current_file = expand('%:p')
  let name = input('Rename ' . expand('%:t') . ' to: ', current_file)
  if !empty(name)
    execute 'saveas ' . name
    call delete(current_file)
  endif
endfunction
