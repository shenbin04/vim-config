function! presenting#Parse()
  let s:page_number = 0
  let l:sep = exists('b:presenting_slide_separator') ? b:presenting_slide_separator : g:presenting_slide_separator
  let pages = map(split(join(getline(1, '$'), "\n"), l:sep), 'split(v:val, "\n")')
  let max_page_number = len(pages) - 1
  return [pages, max_page_number]
endfunction

function! presenting#ShowPage(page_number)
  if a:page_number < 0 || len(s:pages) < a:page_number + 1
    return
  endif

  setlocal textwidth=88
  setlocal noreadonly
  setlocal modifiable

  let offset = (winwidth('%') - &textwidth) / 2
  silent %delete _
  call append(0, map(copy(s:pages[a:page_number]), 'repeat(" ", ' . offset . ') . v:val'))
  call append(0, map(range(1, g:presenting_top_margin), '""'))
  call append(line('$'), map(range(1, winheight('%')), '""'))
  " call append(line('$'), map(range(1, winheight('%') - (line('w$') - line('w0') + 1)), '""'))

  call xolox#notes#refresh_syntax()
  execute 'normal! ' . (g:presenting_top_margin + 1) . 'gg'
  normal! 0

  setlocal buftype=nofile
  setlocal cmdheight=1
  setlocal nocursorcolumn
  setlocal cursorline
  setlocal nomodifiable
  setlocal nonumber
  setlocal norelativenumber
  setlocal noswapfile
  setlocal readonly
  setlocal wrap
  setlocal linebreak
  setlocal breakindent
  setlocal nolist
  setlocal colorcolumn=
  setlocal concealcursor=nc
  setlocal conceallevel=3
  setlocal foldenable
  setlocal foldminlines=0
  setlocal foldcolumn=0
  setlocal foldexpr=presenting#PresentingFolds()
  setlocal foldtext=presenting#PresentingFoldText()
  setlocal fillchars=fold:\ ,vert:\|
  call presenting#UpdateStatusLine()
endfunction

function! presenting#UpdateStatusLine()
  let b:presenting_page_current = s:page_number + 1
  let b:presenting_page_total = len(s:pages)
  let &l:statusline = g:presenting_statusline
endfunction

function! presenting#NextPage(count)
  if s:page_number == s:max_page_number
    return
  endif
  let s:page_number += a:count
  if s:page_number > s:max_page_number
    let s:page_number = s:max_page_number
  endif
  call presenting#ShowPage(s:page_number)
endfunction

function! presenting#PrevPage(count)
  if s:page_number == 0
    return
  endif
  let s:page_number -= a:count
  if s:page_number < 0
    let s:page_number = 0
  endif
  call presenting#ShowPage(s:page_number)
endfunction

function! presenting#Exit()
  if g:presenting_active == 1
    let g:presenting_active = 0
    bdelete! _PRESENTING_SLIDE_
    setlocal fillchars&
    let &colorcolumn=s:colorcolumn
    AirlineToggle
  endif
endfunction

function! presenting#PresentingFolds()
  let line = getline(v:lnum)
  let next = getline(v:lnum + 1)
  if match(line, '.* <$') >= 0
    return '>1'
  elseif match(line, '\ *{{{\w\+') >= 0
    return 'a1'
  elseif match(line, '^\s*$') >=0 && (match(next, '^\s*$') >=0 || match(next, '.* <$') >=0)
    return '<1'
  else
    return '='
  endif
endfunction

function! presenting#PresentingFoldText()
  return ''
endfunction

function! presenting#UnfoldOrNext()
  let last = line('$')
  let current = line('.') + 1
  while current <= last
    if foldclosed(current) > -1
      execute 'normal! ' . current . 'gg'
      normal! zo0
      return
    endif
    let current += 1
  endwhile
  call presenting#NextPage(1)
endfunction

function! presenting#Start(line)
  if g:presenting_active == 1
    echo 'Presenting is running. Please quit first.'
    return
  endif

  let s:filetype = &filetype
  let s:colorcolumn = &colorcolumn
  if !exists('b:presenting_slide_separator') && !exists('g:presenting_slide_separator')
    echom 'Please set b:presenting_slide_separator for "' . &filetype . '" filetype to enable Presenting'
    return
  endif

  let [s:pages, s:max_page_number] = presenting#Parse()

  if empty(s:pages)
    echo 'No page detected!'
    return
  endif

  let page_number = 0
  while page_number <= s:max_page_number
    if index(s:pages[page_number], a:line) >= 0
      let s:page_number = page_number
      break
    endif
    let page_number += 1
  endwhile

  let g:presenting_active = 1

  AirlineToggle
  silent n _PRESENTING_SLIDE_
  call presenting#ShowPage(s:page_number)
  let &filetype=s:filetype
  call presenting#UpdateStatusLine()

  command! -buffer -count=1 PresentingNext call presenting#NextPage(<count>)
  command! -buffer -count=1 PresentingPrev call presenting#PrevPage(<count>)
  command! -buffer PresentingExit call presenting#Exit()

  nnoremap <buffer> <silent> n :PresentingNext<CR>
  nnoremap <buffer> <silent> p :PresentingPrev<CR>
  nnoremap <buffer> <silent> N :PresentingPrev<CR>
  nnoremap <buffer> <silent> q :PresentingExit<CR>
  nnoremap <buffer> <silent> <CR> :call presenting#UnfoldOrNext()<CR>

  autocmd BufWinLeave <buffer> call presenting#Exit()
endfunction
