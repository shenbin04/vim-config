function! python#PYLintArgs()
  let config = findfile('.arc/.pylintrc', '.;')
  let config_path = config != '' ? ' --rcfile ' . shellescape(fnamemodify(config, ':p')) : '-E'
  return '-E -d E1101' . config_path
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
  let pattern = fnamemodify(findfile('BUILD', '.;'), ':~:.:h') . ':' . split(expand('%:r'), '/')[-1]
  call VimuxRunCommand('./pants build-deps --build-deps-prune=True --virtualenv=oscar ' . pattern)
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

function! python#RunTestFile()
  let test_file = util#ExpandRelative('%:p')
  let dir = util#ExpandRelative('%:p:h')
  let python_file = dir . '/' . join(split(expand('%:t'), '_')[0:-2], '_') . '.py'
  let cmd = 'coverage run --branch --include ' . python_file . ' -m pytest ' . test_file . ' && coverage report -m'
  call VimuxRunCommand(cmd)
endfunction
