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
  if &buftype != 'terminal'
    mkview
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

function! util#OpenStash() range
  if !exists('g:stash_url')
    echo 'Please set g:stash_url first'
    return
  endif
  let top = a:firstline
  let bot = a:lastline
  let cmd = '!open ' . g:stash_url . util#ExpandRelative('%:p') . '\#' . top
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
