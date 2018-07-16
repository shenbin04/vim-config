function! GetPrefix()
  let dir = split(util#ExpandRelative('%:p:h'), '/')
  let base = join(dir[0:dir[-1] == '__snapshots__' ? -2 : -1], '/')
  return base . '/' . split(expand('%:t:r'), '\.')[0]
endfunction

function! FindJest(...)
  let prefix = a:0 > 0 ? a:1 : ''
  let root = fnamemodify(finddir('node_modules', '.;'), ':~:.:h')
  let jest = root . '/node_modules/.bin/jest'
  let g:test#javascript#jest#executable = prefix . jest . ' -c ' . root . '/package.json'
endfunction

function! GetCoverage()
  return ' --collectCoverageFrom ' . js#GetJSFileFromTestFile() . ' --coverage '
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

function! js#GetJSFileFromTestFile()
  return GetPrefix() . '.' . expand('%:e')
endfunction

function! js#RunTestFile()
  call FindJest()
  execute ':TestFile' . GetCoverage()
endfunction

function! js#RunTestUpdate()
  call FindJest()
  execute ':TestFile' . GetCoverage() . ' -u'
endfunction

function! js#RunTestWatch()
  call FindJest()
  execute ':TestFile' . GetCoverage() . ' --watch'
endfunction

function! js#RunTestLine()
  call FindJest()
  execute ':TestNearest'
endfunction

function! js#RunTestDebug()
  call FindJest('node debug ')
  execute ':TestNearest'
endfunction

function! js#RunTest(param)
  let root = fnamemodify(finddir('node_modules', '.;'), ':~:.:h')
  call VimuxRunCommand('npm test --prefix ' . root . ' -- ' . a:param)
endfunction

function! js#RunFlow()
  let root = fnamemodify(findfile('.flowconfig', '.;'), ':~:.:h')
  call VimuxRunCommand('npm run flow ' . root)
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

function! js#RequireToImport()
  call VimuxRunCommand('npm run update-require-to-import ' . util#ExpandRelative('%'))
endfunction

function! js#OrganizeImports()
  call VimuxRunCommand('npm run organize-imports ' . util#ExpandRelative('%'))
endfunction

function! js#FindFunction(command)
  execute 'normal! j?\v^\s*\w+(\(.*\)(: \w+)\? \{|(: \w+)\? \= (\(.*\)(: \w+)\? \=\> )\?(\{|.+;))$' . "\<CR>f{V%" . a:command
endfunction

function! js#FindProperty()
  execute "normal! " . "/}\<CR>?\\v\\S+: \\{\<CR>f{V%o"
endfunction

function! js#JSFunctionCallAction(command)
  execute "normal! " . "?\\v^\\s+\\S+\\(\<CR>f(V%o" . a:command
endfunction

function! js#FormatImportBreak()
  execute 'normal! ^'
  call RangeJsBeautify()
  execute 'normal! f{%kA,'
endfunction

function! js#FormatImportJoin()
  execute 'normal! va{Jhxx%lx'
endfunction
