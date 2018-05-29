au FileType markdown let s:presenting_slide_separator = '\v(^|\n)\ze#+'
au FileType notes    let s:presenting_slide_separator = '\v(^|\n)\ze# '

if !exists('g:presenting_active')
  let g:presenting_active = 0
endif

if !exists('g:presenting_statusline')
  let g:presenting_statusline =
    \ '%{b:presenting_page_current}/%{b:presenting_page_total}'
endif

if !exists('g:presenting_top_margin')
  let g:presenting_top_margin = 0
endif

function! PresentingFolds()
  let line = getline(v:lnum)
  if match(line, '.* <$') >= 0
    return '>1'
  elseif match(line, '^\s*$') >= 0
    return '0'
  else
    return '='
  endif
endfunction

function! PresentingFoldText()
  return substitute(getline(v:foldstart), '\v(.*) \<$', '\1', '')
endfunction

function! s:Start()
  if g:presenting_active == 1
    echo 'Presenting is running. Please quit first.'
    return
  endif

  let s:filetype = &filetype
  if !exists('b:presenting_slide_separator') && !exists('s:presenting_slide_separator')
    echom 'Please set b:presenting_slide_separator for "' . &filetype . '" filetype to enable Presenting'
    return
  endif

  let s:page_number = 0
  let s:max_page_number = 0
  let s:pages = []
  call s:Parse()

  if empty(s:pages)
    echo 'No page detected!'
    return
  endif

  let g:presenting_active = 1

  silent n _PRESENTING_SLIDE_
  call s:ShowPage(0)
  let &filetype=s:filetype
  call s:UpdateStatusLine()

  command! -buffer -count=1 PresentingNext call s:NextPage(<count>)
  command! -buffer -count=1 PresentingPrev call s:PrevPage(<count>)
  command! -buffer PresentingExit call s:Exit()

  nnoremap <buffer> <silent> n :PresentingNext<CR>
  nnoremap <buffer> <silent> p :PresentingPrev<CR>
  nnoremap <buffer> <silent> N :PresentingPrev<CR>
  nnoremap <buffer> <silent> q :PresentingExit<CR>

  autocmd BufWinLeave <buffer> call s:Exit()
endfunction

function! s:ShowPage(page_number)
  if a:page_number < 0 || len(s:pages) < a:page_number + 1
    return
  endif

  let s:page_number = a:page_number

  setlocal noreadonly
  setlocal modifiable
  silent %delete _
  call append(0, map(copy(s:pages[s:page_number]), 'repeat(" ", 10) . v:val'))
  call append(0, map(range(1, g:presenting_top_margin), '""'))
  normal! gg
  call append(line('$'), map(range(1, winheight('%')), '""'))
  " call append(line('$'), map(range(1, winheight('%') - (line('w$') - line('w0') + 1)), '""'))

  setlocal buftype=nofile
  setlocal cmdheight=1
  setlocal nocursorcolumn
  setlocal nocursorline
  setlocal nomodifiable
  setlocal nonumber
  setlocal norelativenumber
  setlocal noswapfile
  setlocal readonly
  setlocal wrap
  setlocal linebreak
  setlocal breakindent
  setlocal nolist
  setlocal foldexpr=PresentingFolds()
  setlocal foldtext=PresentingFoldText()
  setlocal fillchars=fold:\ ,vert:\|
  call s:UpdateStatusLine()
endfunction

function! s:NextPage(count)
  let s:page_number += a:count
  if s:page_number > s:max_page_number
    let s:page_number = s:max_page_number
  endif
  call s:ShowPage(s:page_number)
endfunction

function! s:PrevPage(count)
  let s:page_number -= a:count
  if s:page_number < 0
    let s:page_number = 0
  endif
  call s:ShowPage(s:page_number)
endfunction

function! s:Exit()
  if g:presenting_active == 1
    let g:presenting_active = 0
    bdelete! _PRESENTING_SLIDE_
    setlocal fillchars&
  endif
endfunction

function! s:UpdateStatusLine()
  let b:presenting_page_current = s:page_number + 1
  let b:presenting_page_total = len(s:pages)
  let &l:statusline = g:presenting_statusline
endfunction

function! s:Parse()
  let l:sep = exists('b:presenting_slide_separator') ? b:presenting_slide_separator : s:presenting_slide_separator
  let s:pages = map(split(join(getline(1, '$'), "\n"), l:sep), 'split(v:val, "\n")')
  let s:max_page_number = len(s:pages) - 1
endfunction

command! StartPresenting call s:Start()
command! PresentingStart call s:Start()

" vim:ts=2:sw=2:expandtab
