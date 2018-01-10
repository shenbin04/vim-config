function! GetPrefix()
  let dir = split(util#ExpandRelative('%:p:h'), '/')
  let base = join(dir[0:dir[-1] == '__snapshots__' ? -2 : -1], '/')
  echom base
  return base . '/' . split(expand('%:t:r'), '\.')[0]
endfunction

function! js#OpenJSFile()
  let prefix = GetPrefix()
  for extension in ['.js', '.jsx']
    let file = prefix . extension
    if util#TryOpenFile(file, 'Cannot find javascript file ' . file)
      return
    endif
  endfor
endfunction

function! js#OpenTestFile()
  let prefix = GetPrefix()
  for extension in ['.js', '.jsx']
    let file = prefix . '.test' . extension
    if util#TryOpenFile(file, 'Cannot find test file ' . file)
      return
    endif
  endfor
endfunction

function! js#OpenSnapshotFile()
  for extension in ['.js', '.jsx']
    let file = util#ExpandRelative('%:p:h') . '/__snapshots__/' . split(expand('%:t:r'), '\.')[0] . '.test' . extension . '.snap'
    if util#TryOpenFile(file, 'Cannot find snapshot file ' . file)
      return
    endif
  endfor
endfunction

function! js#OpenScssFile()
  let file = GetPrefix() . '.scss'
  call util#TryOpenFile(file, 'Cannot find scss file ' . file)
endfunction

function! js#ESLintArgs()
  let rules = finddir('.arc/linters/eslint_rules', '.;')
  return rules != '' ? '--rulesdir ' . shellescape(fnamemodify(rules, ':p:h')) : ''
endfunction

function! js#RunJestOnBuffer()
  call RunJest(util#ExpandRelative('%'))
endfunction

function! js#RunJestOnBufferUpdate()
  call RunJest(util#ExpandRelative('%') . ' -- -u')
endfunction

function! js#RunJestOnBufferWatch()
  call RunJest(util#ExpandRelative('%') . ' -- --watch')
endfunction

function! js#RunJestFocused()
  execute 'normal! j'
  let test_name = JestSearchForTest('\<test(\|\<it(\|\<test.only(')

  if test_name == ''
    echoerr "Couldn't find test name to run focused test."
    return
  endif

  call RunJest(util#ExpandRelative('%') . ' -- -t ' . test_name)
endfunction

function! JestSearchForTest(fragment)
  let line_num = search(a:fragment, 'bs')
  if line_num > 0
    return matchlist(getline(line_num), '\(''\|"\).*\(''\|"\)')[0]
  else
    return ''
  endif
endfunction

function! RunJest(test)
  call VimuxRunCommand('npm test ' . a:test)
endfunction

function! js#RequireToImport()
  call VimuxRunCommand('npm run update-require-to-import ' . util#ExpandRelative('%'))
endfunction

function! js#OrganizeImports()
  call VimuxRunCommand('npm run organize-imports ' . util#ExpandRelative('%'))
endfunction
