function! python#PYLintArgs()
  let config = findfile('.arc/.pylintrc', '.;')
  return config != '' ? '--rcfile ' . shellescape(fnamemodify(config, ':p')) : ''
endfunction

function! python#OpenPythonFile()
  let dir = util#ExpandRelative('%:p:h')
  let file = dir . '/' . join(split(expand('%:t'), '_')[0:-2], '_') . '.py'
  echom file
  call util#TryOpenFile(file, 'Cannot find python file ' . file)
endfunction

function! python#OpenTestFile()
  let file = util#ExpandRelative('%:p:r') . '_test.py'
  echom file
  call util#TryOpenFile(file, 'Cannot find test file ' . file)
endfunction
