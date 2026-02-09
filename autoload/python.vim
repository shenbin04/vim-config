function! python#RunTestFile(...)
  call util#Topen()
  TestFile
endfunction

function! python#DebugTestFile()
  call util#Topen()
  TestNearest -s
endfunction

function! s:ProcessError(input)
  let result = substitute(a:input, '\n', '', 'g')
  let result = substitute(result, '<.*>', '"\0"', 'g')
  let result = substitute(result, '\vu(''.{-}'')', '\1', 'g')
  return result
endfunction

function! python#ShowError() abort
  if !exists('g:shell_prompt')
    call util#EchoError('Please set g:shell_prompt first.')
    return
  endif

  let origin_win_id = win_getid()

  call win_gotoid(util#GetNeotermWindow())
  normal! Gzb

  call search('\v' . g:shell_prompt, 'b')
  if search('\v^E\s+AssertionError: \zs')
    let @x = ''
    let @y = ''
    if search('Expected call:', 'cW')
      normal! f(
      silent normal! "xyib
      call search('Actual call:')
      normal! f(
      silent normal! "yyib
    elseif search('Lists differ:', 'cW')
      normal! f[
      silent normal! "xy%
      normal! %2W
      silent normal! "yy%
    else
      silent normal! "xy%
      normal! %2W
      silent normal! v}"yy
    endif

    call search('\v' . g:shell_prompt, 'b')
    call search('\v^\S+:\d+:')
    normal! "zy2t:

    call win_gotoid(origin_win_id)

    let [path, line; rest] = split(@z, ':')
    if filereadable(path)
      execute 'edit ' . path
      execute line
    endif

    let x = s:ProcessError(@x)
    let y = s:ProcessError(@y)

    botright 8new
    silent execute 'read !black -c ' . shellescape(x)
    diffthis
    setlocal buftype=nofile bufhidden=delete filetype=text foldcolumn=0 noswapfile nomodifiable

    vertical rightbelow new
    silent execute 'read !black -c ' . shellescape(y)
    diffthis
    setlocal buftype=nofile bufhidden=delete filetype=text foldcolumn=0 noswapfile nomodifiable
    normal gg]c
  endif

  call win_gotoid(origin_win_id)
endfunction

function! python#ShowErrorNext()
  let origin_win_id = win_getid()
  wincmd j
  normal ]c
  call win_gotoid(origin_win_id)
endfunction

function! python#ShowErrorPrev()
  let origin_win_id = win_getid()
  wincmd j
  normal [c
  call win_gotoid(origin_win_id)
endfunction

function! python#NewTestFile()
  let file_name = util#GetBaseFileName()
  let test_file = expand('%:p:h') . '/' . file_name . '_test.' . expand('%:e')

  if !util#TryOpenFile(test_file)
    exec 'edit ' . test_file
    normal int,e
  endif
endfunction
