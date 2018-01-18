function! python#PYLintArgs()
  let config = findfile('.arc/.pylintrc', '.;')
  return config != '' ? '--rcfile ' . shellescape(fnamemodify(config, ':p')) : ''
endfunction

function! python#OpenPythonFile()
  let dir = util#ExpandRelative('%:p:h')
  let file = dir . '/' . join(split(expand('%:t'), '_')[0:-2], '_') . '.py'
  call util#TryOpenFile(file, 'Cannot find python file ' . file)
endfunction

function! python#OpenTestFile()
  let file = util#ExpandRelative('%:p:r') . '_test.py'
  call util#TryOpenFile(file, 'Cannot find test file ' . file)
endfunction

function! python#OpenBuildFile()
  let file = findfile('BUILD', '.;')
  call util#TryOpenFile(file, 'Cannot find BUILD file ' . file)
endfunction

function! python#BuildDeps()
  let pattern = fnamemodify(findfile('BUILD', '.;'), ':~:.:h') . ':'
  call VimuxRunCommand('./pants build-deps --virtualenv=oscar ' . pattern)
endfunction

function! python#TargetGen()
  let pattern = fnamemodify(findfile('BUILD', '.;'), ':~:.:h') . '/*.py'
  call VimuxRunCommand('./pants target-gen -- ' . pattern)
endfunction

function! python#GenAll()
  call python#GenThrift()
  call python#GenProtobuf()
endfunction

function! python#GenThrift()
  call VimuxRunCommand('./pants gen-thrift-py thrift/src::')
endfunction

function! python#GenProtobuf()
  call VimuxRunCommand('./pants gen-protobuf-py protobuf/src::')
endfunction

function! python#InstallExtDeps(target)
  let command = 'TARGET_EXT_DEPS=`./pants dependencies --dependencies-external-only ' . a:target . ' | sort | uniq`
  \ && xargs pip install --no-cache-dir <<< "$TARGET_EXT_DEPS"'
  call VimuxRunCommand(command)
endfunction

