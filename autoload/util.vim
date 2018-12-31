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

function! util#TryOpenFile(file, message)
  if filereadable(a:file)
    if util#ExpandRelative('%:p') != a:file
      exe 'edit ' . a:file
    endif
    return 1
  else
    return 0
  endif
endfunction

function! util#ExpandRelative(pattern)
  return fnamemodify(expand(a:pattern), ':~:.')
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

function! util#zoom()
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
  let cmd = '!open ' . g:stash_url . util#ExpandRelativeToGit('%:p') . '\#' . top
  if bot > top
    let cmd = cmd . '-' . bot
  endif
  silent execute cmd
endfunction

function! util#OpenDiffusion() range
  if !exists('g:diffusion_url')
    echo 'Please set g:diffusion_url first'
    return
  endif
  let top = a:firstline
  let bot = a:lastline
  let cmd = '!open ' . g:diffusion_url . util#ExpandRelativeToGit('%:p') . '\$' . top
  if bot > top
    let cmd = cmd . '-' . bot
  endif
  silent execute cmd
endfunction

function! util#GrepOperator(type)
  let saved_unnamed_register = @@
  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif

  silent execute 'GrepperAg ' . shellescape(@@)
  let @@ = saved_unnamed_register
endfunction

function! util#ClearHighlight()
  if exists('g:plugs["jedi-vim"]')
    call jedi#remove_usages()
  endif
endfunction

function! util#GitDiff()
  if expand('%') ==# ''
    return
  endif
  Gdiff
  call s:diff_window_syntax('diff')
endfunction

function! util#GitDiffEnd()
  if s:diff_window_count() == 2
    call s:diff_window_syntax('on')
  endif
endfunction

function! s:diff_window_syntax(syntax) abort
  for nr in range(1, winnr('$'))
    if getwinvar(nr, '&diff')
      call setbufvar(winbufnr(nr), '&syntax', a:syntax)
    endif
  endfor
endfunction

function! s:diff_window_count() abort
  let c = 0
  for nr in range(1,winnr('$'))
    let c += getwinvar(nr,'&diff')
  endfor
  return c
endfunction
