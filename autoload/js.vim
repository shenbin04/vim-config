let s:js_function_regex = '\v^  \w+(\(.*\)(: \w+)? \{|(: \w+)? \= \(.*\)(: \w+)? \=\> (\{|.+;))$'
let s:js_object_regex = '\v\{\zs.+\ze\}.*'
let s:js_jsx_tag_regex = '\v^(\s*)(.*)(\<(\S+)[^>]*\>)(.*)(\<\/\4\>)(;?)$'
let s:js_jsx_open_tag_regex = '\v^(\s*)(.*)(\<\S+) (.{-1,})( ?/{,1}\>)(.*)'

let s:indent = repeat(' ', &shiftwidth)

function! s:GetPrefix()
  let dir = split(util#ExpandRelative('%:p:h'), '/')
  let base = join(dir[0:dir[-1] == '__snapshots__' ? -2 : -1], '/')
  return base . '/' . util#GetBaseFileName()
endfunction

function! s:FindJest(...)
  let prefix = a:0 > 0 ? a:1 : ''
  let root = fnamemodify(finddir('node_modules', '.;'), ':~:.:h')

  let jest = root . '/node_modules/.bin/jest'
  let config = root . '/package.json'

  let jest_project_config = findfile('jest.config.js', '.;')
  if jest_project_config != ''
    let config = jest_project_config
  endif

  let g:test#javascript#jest#executable = 'NODE_ENV=testing NODE_PATH=$(pwd) ' . prefix . jest . ' -c ' . config
endfunction

function! s:GetCoverage()
  let test_file = js#GetJSFileFromTestFile()
  let root = fnamemodify(finddir('node_modules', '.;'), ':~:.:h')
  if root !=# '.'
    let test_file = test_file[matchend(test_file, root) + 1:]
  endif
  return ' --collectCoverageFrom ' . test_file . ' --coverage '
endfunction

function! js#OpenJSFile()
  let prefix = s:GetPrefix()
  for extension in ['.js', '.jsx']
    let file = prefix . extension
    if util#TryOpenFile(file, 'Cannot find javascript file ' . file)
      return
    endif
  endfor
endfunction

function! js#GetJSFileFromTestFile()
  return s:GetPrefix() . '.' . expand('%:e')
endfunction

function! js#RunTestFile()
  call s:FindJest()
  call util#Topen()
  execute ':TestFile' . s:GetCoverage()
endfunction

function! js#RunTestUpdate()
  call s:FindJest()
  call util#Topen()
  execute ':TestFile' . s:GetCoverage() . ' -u'
endfunction

function! js#RunTestWatch()
  call s:FindJest()
  call util#Topen()
  execute ':TestFile' . s:GetCoverage() . ' --watch'
endfunction

function! js#RunTestLine()
  call s:FindJest()
  call util#Topen()
  execute ':TestNearest'
endfunction

function! js#RunTestDebug()
  call s:FindJest('node --inspect ')
  call util#Topen()
  execute ':TestNearest'
endfunction

function! js#RunTest(param)
  call s:FindJest()
  call util#Topen()
  execute ':T ' . g:test#javascript#jest#executable . ' ' . a:param
endfunction

function! js#RunFlow()
  let root = fnamemodify(findfile('.flowconfig', '.;'), ':~:.:h')
  call util#Topen()
  execute ':T flow ' . root . ' --show-all-errors'
endfunction

function! js#OpenTestFile()
  let prefix = s:GetPrefix()
  for extension in ['.js', '.jsx']
    let file = prefix . '.test' . extension
    if util#TryOpenFile(file, 'Cannot find test file ' . file)
      return
    endif
  endfor
endfunction

function! js#OpenSnapshotFile()
  for extension in ['.js', '.jsx']
    let file = util#ExpandRelative('%:p:h') . '/__snapshots__/' . util#GetBaseFileName() . '.test' . extension . '.snap'
    if util#TryOpenFile(file, 'Cannot find snapshot file ' . file)
      return
    endif
  endfor
endfunction

function! js#OpenCssFile()
  let prefix = s:GetPrefix()
  for extension in ['.css', '.scss', '.sass']
    let file = prefix . extension
    if util#TryOpenFile(file, 'Cannot find css file ' . file)
      return
    endif
  endfor
endfunction

function! js#ESLintArgs()
  let rules = finddir('.arc/linters/eslint_rules', '.;')
  return rules != '' ? '--rulesdir ' . shellescape(fnamemodify(rules, ':p:h')) : ''
endfunction

function! js#RequireToImport()
  call util#Topen()
  execute ':T npm run update-require-to-import ' . util#ExpandRelative('%')
endfunction

function! js#OrganizeImports()
  call util#Topen()
  execute ':T npm run organize-imports ' . util#ExpandRelative('%')
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

function! js#FormatObjectBreak()
  let lnum = line('.')
  let line = getline('.')
  let [str, start, end] = matchstrpos(line, s:js_object_regex)
  if !empty(str)
    let indent = repeat(' ', indent(lnum))
    let imports = sort(map(split(str, ','), {k, v -> indent . s:indent . xolox#misc#str#trim(v) . ','}))
    call setline(lnum, line[:start - 1])
    call append(lnum, indent . line[end:])
    call append(lnum, imports)
  endif
endfunction

function! js#FormatObjectSort()
  let lnum = line('.')
  let line = getline('.')
  let [str, start, end] = matchstrpos(line, s:js_object_regex)
  if !empty(str)
    let imports = join(sort(map(split(str, ','), {k, v -> xolox#misc#str#trim(v)})), ', ')
    call setline(lnum, line[:start - 1] . imports . line[end:])
  else
    normal vi{ss
  endif
endfunction

function! js#FormatObjectJoin()
  if getline('.') !~# s:js_object_regex
    normal! $va{Jhxx%lx
  endif
endfunction

function! js#FormatJsxBreak()
  let lnum = line('.')
  let line = getline('.')
  if line =~# s:js_jsx_open_tag_regex
    let [_, indent, variable, jsx_tag, prop, end_tag, trailing; rest] = matchlist(line, s:js_jsx_open_tag_regex)
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
  if line =~# s:js_jsx_open_tag_regex
    let [_, indent, variable, jsx_tag, prop, end_tag, trailing; rest] = matchlist(line, s:js_jsx_open_tag_regex)
    let props = join(sort(split(prop, '[}"]\zs ')), ' ')
    call setline(lnum, indent . variable . jsx_tag . ' ' . props . end_tag . trailing)
  else
    normal viiss
  endif
endfunction

function! js#FormatJsxJoin()
  normal! $va<J
  if getline('.') =~# '\v \>$'
    normal! x
  endif
endfunction

function! js#FormatTagBreak()
  let lnum = line('.')
  let line = getline('.')
  if line =~# s:js_jsx_tag_regex
    let [_, indent, variable, open_tag, _, content, close_tag, trailing; rest] = matchlist(line, s:js_jsx_tag_regex)
    if empty(variable)
      call setline(lnum, indent . open_tag)
      call append(lnum, [indent . s:indent . content, indent . close_tag . trailing])
    else
      call setline(lnum, indent . variable . '(')
      let lines = []
      call add(lines, indent . s:indent . open_tag)
      call add(lines, indent . repeat(s:indent, 2) . content)
      call add(lines, indent . s:indent . close_tag)
      call add(lines, indent . ')' . trailing)
      call append(lnum, lines)
    endif
  endif
endfunction

function! js#FormatTagJoin()
  let lnum = line('.')
  let line = getline(lnum)
  let prev = getline(lnum - 1)
  let next = getline(lnum + 1)
  if line =~# s:js_jsx_tag_regex && prev =~# '\v.+ = \($' && next =~# '\v^\s*\)'
    let line = getline(lnum - 1)[:-2] . xolox#misc#str#trim(getline(lnum)) . xolox#misc#str#trim(getline(lnum + 1))[1:]
    normal! djk
    call setline(lnum - 1, line)
  else
    call search('\v^\s+\<[^?>]*\>$', 'b')
    let joinspaces = &joinspaces
    let &joinspaces = 0
    normal vatJxf/%f>lx
    let &joinspaces = joinspaces
  endif
endfunction

function! js#ShowFlowCoverage()
  if exists('b:flow_coverage_status')
    echo b:flow_coverage_status
  endif
endfunction

function! js#NewTestFile()
  let file_name = util#GetBaseFileName()
  let test_file = expand('%:p:h') . '/' . file_name . '.test.' . expand('%:e')

  if !util#TryOpenFile(test_file, '')
    exec 'edit ' . test_file
    normal intf,e
  endif
endfunction
