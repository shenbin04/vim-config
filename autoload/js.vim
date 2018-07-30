let s:js_function_regex = '\v^\s*\w+(\(.*\)(: \w+)? \{|(: \w+)? \= (\(.*\)(: \w+)? \=\> )?(\{|.+;))$'
let s:js_named_imports_regex = '\vimport \{\zs.+\ze\}.+'
let s:js_jsx_tag_regex = '\v(\s+)(.*)(\<\S+) (.{-1,})( ?/{,1}\>)(.*)'

let s:indent = repeat(' ', &shiftwidth)

function! GetPrefix()
  let dir = split(util#ExpandRelative('%:p:h'), '/')
  let base = join(dir[0:dir[-1] == '__snapshots__' ? -2 : -1], '/')
  return base . '/' . split(expand('%:t:r'), '\.')[0]
endfunction

function! FindJest(...)
  let prefix = a:0 > 0 ? a:1 : ''
  let root = fnamemodify(finddir('node_modules', '.;'), ':~:.:h')
  let jest = root . '/node_modules/.bin/jest'
  let g:test#javascript#jest#executable = 'NODE_PATH=$(pwd) ' . prefix . jest . ' -c ' . root . '/package.json'
endfunction

function! GetCoverage()
  let test_file = js#GetJSFileFromTestFile()
  let root = fnamemodify(finddir('node_modules', '.;'), ':~:.:h')
  if root !=# '.'
    let test_file = test_file[matchend(test_file, root) + 1:]
  endif
  return ' --collectCoverageFrom ' . test_file . ' --coverage '
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
  let lnum = line('.')
  let line = getline('.')
  let [str, start, end] = matchstrpos(line, s:js_named_imports_regex)
  if !empty(str)
    let imports = sort(map(split(str, ','), {k, v -> repeat(' ', &shiftwidth) . xolox#misc#str#trim(v) . ','}))
    call setline(lnum, line[:start - 1])
    call append(lnum, line[end:])
    call append(lnum, imports)
  endif
endfunction

function! js#FormatImportSort()
  let lnum = line('.')
  let line = getline('.')
  let [str, start, end] = matchstrpos(line, s:js_named_imports_regex)
  if !empty(str)
    let imports = join(sort(map(split(str, ','), {k, v -> xolox#misc#str#trim(v)})), ', ')
    call setline(lnum, line[:start - 1] . imports . line[end:])
  else
    normal vi{ss
  endif
endfunction

function! js#FormatImportJoin()
  if empty(matchstr(getline('.'), s:js_named_imports_regex))
    normal! va{Jhxx%lx
  endif
endfunction

function! js#FormatJsxBreak()
  let lnum = line('.')
  let line = getline('.')
  if line =~# s:js_jsx_tag_regex
    let [_, indent, variable, jsx_tag, prop, end_tag, trailing; rest] = matchlist(line, s:js_jsx_tag_regex)
    if empty(variable)
      call setline(lnum, indent . jsx_tag)
      let props = map(sort(split(prop, '[}"]\zs ')), {k, v -> indent . s:indent . v})
      call add(props, indent . xolox#misc#str#trim(end_tag))
      call append(lnum, props)
    else
      call setline(lnum, indent . variable . '(')
      let props = map(sort(split(prop, '[}"]\zs ')), {k, v -> indent . repeat(s:indent, 2) . v})
      call insert(props, indent . s:indent . jsx_tag)
      call add(props, indent . s:indent . xolox#misc#str#trim(end_tag))
      call add(props, indent . ')' . trailing)
      call append(lnum, props)
    endif
  endif
endfunction

function! js#FormatJsxSort()
  let lnum = line('.')
  let line = getline('.')
  if line =~# s:js_jsx_tag_regex
    let [_, indent, variable, jsx_tag, prop, end_tag, trailing; rest] = matchlist(line, s:js_jsx_tag_regex)
    let props = join(sort(split(prop, '[}"]\zs ')), ' ')
    call setline(lnum, indent . variable . jsx_tag . ' ' . props . end_tag . trailing)
  else
    normal viiss
  endif
endfunction

function! js#FormatJsxJoin()
  let lnum = line('.')
  let line = getline(lnum)
  let prev = getline(lnum - 1)
  let next = getline(lnum + 1)
  if line =~# s:js_jsx_tag_regex && prev =~# '\v.+ = \($' && next =~# '\v^\s*\)'
    let line = getline(lnum - 1)[:-2] . xolox#misc#str#trim(getline(lnum)) . xolox#misc#str#trim(getline(lnum + 1))[1:]
    normal! djk
    call setline(lnum - 1, line)
  else
    normal! $va<J
  endif
endfunction
