function! InferCovModules()
  " Check if we're in a Python test file
  if expand('%:t') !~ '^test_.*\.py$' && expand('%:t') !~ '_test\.py$'
    echo "Not a Python test file"
    return ""
  endif

  let l:imports = []

  " Read the current buffer
  let l:lines = getline(1, '$')

  " Extract imports from the test file
  for l:line in l:lines
    " Match: from module import ...
    let l:from_match = matchstr(l:line, '^\s*from\s\+\([a-zA-Z_][a-zA-Z0-9_.]*\)\s\+import')
    if !empty(l:from_match)
      let l:module = matchstr(l:from_match, 'from\s\+\zs[a-zA-Z_][a-zA-Z0-9_.]*\ze\s\+import')
      if !empty(l:module) && l:module !~ '^\(pytest\|unittest\|mock\|fixtures\|conftest\)'
        call add(l:imports, l:module)
      endif
    endif

    " Match: import module
    let l:import_match = matchstr(l:line, '^\s*import\s\+\([a-zA-Z_][a-zA-Z0-9_.]*\)')
    if !empty(l:import_match)
      let l:module = matchstr(l:import_match, 'import\s\+\zs[a-zA-Z_][a-zA-Z0-9_.]*')
      if !empty(l:module) && l:module !~ '^\(pytest\|unittest\|mock\|fixtures\|conftest\)'
        call add(l:imports, l:module)
      endif
    endif
  endfor

  " Get test file name and normalize to find matching implementation module
  let l:testfile = expand('%:t:r')
  let l:normalized = substitute(l:testfile, '^test_', '', '')
  let l:normalized = substitute(l:normalized, '_test$', '', '')

  " Find the import that matches the normalized test file name
  for l:imp in l:imports
    " Check if the import matches the normalized name
    let l:imp_base = split(l:imp, '\.')[-1]
    if l:imp_base == l:normalized
      return l:imp
    endif
  endfor

  " If no exact match, try to find a module containing the normalized name
  for l:imp in l:imports
    if l:imp =~ l:normalized
      return l:imp
    endif
  endfor

  return ""
endfunction

function! python#RunTestFile(...)
  let l:file = expand('%:p')
  let l:covmod = InferCovModules()

  if empty(l:covmod)
    echo "Couldn't infer a project module from imports in this test. (All imports resolved outside repo?)"
    return
  endif

  let g:test#python#pytest#options = '--cov=' . shellescape(l:covmod) . ' --cov-report=term-missing'

  call util#Topen()
  TestFile
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
