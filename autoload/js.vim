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

let s:js_function_regex = '\v^\s*\w+(\(.*\)(: \w+)? \{|(: \w+)? \= (\(.*\)(: \w+)? \=\> )?(\{|.+;))$'

function! js#FindFunction(command)
  execute 'normal! j?' . escape(s:js_function_regex, '?') . "\<CR>$V%" . a:command
endfunction

function! js#FindFunctionNext()
  call search(s:js_function_regex)
endfunction

function! js#ClassFunctionToClassProperty()
  let line = getline('.')
  let pattern = '\v^(\s+\w+)(\(.*\)) \{$'
  if match(line, pattern) >= 0
    let result = substitute(line, pattern, {m -> m[1] . ' = ' .  m[2] . ' => {'}, '')
    call setline(line('.'), result)
  else
    echo 'Not a class function.'
  endif
endfunction

function! js#ToArrowFunction()
  let line = getline('.')
  let pattern_function = '\v^function (\w+)(\(.*\)) \{$'
  let pattern_function_anonymous = '\v^(.+)function(\(.*\)) \{$'
  if match(line, pattern_function_anonymous) >= 0
    let result = substitute(line, pattern_function_anonymous, {m -> m[1] . m[2] . ' => {'}, '')
    call setline(line('.'), result)
  elseif match(line, pattern_function) >=0
    let result = substitute(line, pattern_function, {m -> 'const ' . m[1] . ' = ' . m[2] . ' => {'}, '')
    call setline(line('.'), result)
    normal! $%a;
  else
    echo 'Not a function.'
  endif
endfunction

function! js#FindFunctionPrevious()
  call search(s:js_function_regex, 'b')
endfunction

function! js#FindProperty()
  execute "normal! /}\<CR>?\\v\\w+: \\{\<CR>$V%"
endfunction

function! js#FindTestCase(command)
  execute "normal! j?\\v^\\s+it\\('.+'\<CR>$V%" . a:command
endfunction

function! js#FormatImportBreak()
  execute 'normal! ^'
  call RangeJsBeautify()
  execute 'normal! f{%kA,'
endfunction

function! js#FormatImportJoin()
  execute 'normal! va{Jhxx%lx'
endfunction
