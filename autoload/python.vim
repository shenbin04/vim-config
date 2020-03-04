function! python#OpenPythonFile()
  let dir = util#ExpandRelative('%:p:h')
  let file = dir . '/' . join(split(expand('%:t'), '_')[0:-2], '_') . '.py'
  call util#TryOpenFile(file)
endfunction

function! python#OpenTestFile()
  let file = util#ExpandRelative('%:p:r') . '_test.py'
  call util#TryOpenFile(file)
endfunction

function! python#OpenBuildFile()
  let file = findfile('BUILD', '.;')
  call util#TryOpenFile(file)
endfunction

function! python#MakePants()
  let pattern = fnamemodify(findfile('BUILD', '.;'), ':~:.:h') . ':' . split(expand('%:r'), '/')[-1]
  call util#Topen()
  execute ':T engshare/bin/mkpantsenv oscar ' . pattern
endfunction

function! python#BuildDeps()
  let pattern = fnamemodify(findfile('BUILD', '.;'), ':~:.:h') . ':' . split(expand('%:r'), '/')[-1]
  call util#Topen()
  execute ':T ./pants build-deps --build-deps-prune=True --virtualenv=oscar ' . pattern
endfunction

function! python#BuildDepsAll()
  call util#Topen()
  execute ':T ./engshare/bin/update-build-files'
endfunction

function! python#TargetGen()
  let pattern = fnamemodify(findfile('BUILD', '.;'), ':~:.:h') . '/*.py'
  call util#Topen()
  execute ':T ./pants target-gen -- ' . pattern
endfunction

function! python#GenThrift()
  call util#Topen()
  execute ':T ./pants gen-thrift-py thrift/src::'
endfunction

function! python#GenProtobuf()
  call util#Topen()
  execute ':T ./pants gen-protobuf-py protobuf/src::'
endfunction

function! python#InstallDeps(target)
  call util#Topen()
  execute ':T ./engshare/bin/mkpantsenv oscar ' . a:target
endfunction

function! python#RunTestFile()
  let test_file = util#ExpandRelative('%:p')
  let dir = util#ExpandRelative('%:p:h')
  let python_file = dir . '/' . join(split(expand('%:t'), '_')[0:-2], '_') . '.py'
  let coverage_file = 'COVERAGE_FILE=.coverage.python'
  let command = coverage_file . ' coverage run --branch --include ' . python_file
        \ . ' -m pytest --pdb ' . test_file
        \ . ' && ' . coverage_file . ' coverage report -m'

  call util#Topen()
  execute ':T ' . command
endfunction

function! python#DebugTestFile()
  normal! Oimport ipdb; ipdb.set_trace()
  w
  call util#Topen()
  TestNearest -s
endfunction

function! s:ProcessError(input)
  let result = substitute(a:input, '\n', '', 'g')
  let result = substitute(result, '<.*>', '"\0"', 'g')
  let result = substitute(result, 'u\(''\S*''\)', '\1', 'g')
  return result
endfunction

function! s:FormatError(input)
  let black_linelength = g:black_linelength
  let g:black_linelength = 80
  silent! Black
  let g:black_linelength = black_linelength
endfunction

function! python#ShowError() abort
  if !exists('g:shell_prompt')
    echohl ErrorMsg
    echo 'Please set g:shell_prompt first'
    echohl None
    return
  endif

  let origin_win_id = win_getid()

  call win_gotoid(util#get_neoterm_window())
  normal! Gzb

  call search('\v' . xolox#misc#escape#substitute(g:shell_prompt), 'b')
  if search('\v^E\s+AssertionError: \zs')
    let @x = ''
    let @y = ''
    if search('Expected call:', 'cW')
      normal! f(
      silent normal! "xyib
      call search('Actual call:')
      normal! f(
      silent normal! "yyib
    else
      silent normal! "xy%
      normal! %2W
      silent normal! "yy%
    endif
    call search('\v^E\s+AssertionError: \zs', 'b')

    call win_gotoid(origin_win_id)

    let x = s:ProcessError(@x)
    let y = s:ProcessError(@y)

    botright 8new
    call setline(1, x)
    call s:FormatError(x)
    diffthis
    setlocal buftype=nofile bufhidden=delete filetype=python foldcolumn=0 noswapfile nomodifiable

    vertical rightbelow new
    call setline(1, y)
    call s:FormatError(y)
    diffthis
    setlocal buftype=nofile bufhidden=delete filetype=python foldcolumn=0 noswapfile nomodifiable

    normal ]c
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
