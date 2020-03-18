let s:js_function_regex = '\v^  \w+(\(.*\)(: \w+)? \{|(: \w+)? \= \(.*\)(: \w+)? \=\> (\{|.+;))$'
let s:js_class_regex = '\v^(export )?class \w+ extends .*$'
let s:js_object_regex = '\v\{\zs.+\ze\}.*'
let s:js_jsx_open_tag_regex = '\v^(\s*)(.*)(\<\S+) (.{-1,})( ?/{,1}\>)(.*)'

let s:indent = repeat(' ', &shiftwidth)

function! s:GetPrefix()
  let dir = split(util#ExpandRelative('%:p:h'), '/')
  let base = join(dir[0:dir[-1] == '__snapshots__' ? -2 : -1], '/')
  return base . '/' . util#GetBaseFileName()
endfunction

function! s:FindRoot()
  let roots = finddir('node_modules', '.;', -1)
  for root in roots
    if filereadable(root . '/.bin/jest')
      return fnamemodify(root, ':.:h')
    endif
  endfor
endfunction

function! s:PrepareJest(...)
  let options = a:0 > 0 ? a:1 : {}
  let root = s:FindRoot()

  let cmd = ''

  if root != '.'
    echohl ErrorMsg
    echom 'Please run tests in project root.'
    echohl NONE
    return
  endif

  let g:test#javascript#jest#prefix = ['NODE_ENV=testing', 'NODE_PATH=.'] + get(options, 'prefix', [])
  let g:test#javascript#jest#project = get(options, 'project', 1)

  return 1
endfunction

function! s:GetCoverage()
  let test_file = js#GetJSFileFromTestFile()
  return ' --collectCoverageFrom ' . test_file . ' --coverage '
endfunction

function! js#OpenJSFile()
  let prefix = s:GetPrefix()
  for extension in ['.js', '.jsx']
    let file = prefix . extension
    if util#TryOpenFile(file)
      return
    endif
  endfor
endfunction

function! js#GetJSFileFromTestFile()
  return s:GetPrefix() . '.' . expand('%:e')
endfunction

function! s:RunTest(...)
  let options = a:0 > 1 ? a:2 : {}
  if s:PrepareJest(options)
    call util#Topen()
    execute a:1()
  endif
endfunction

function! js#RunTestsInProject(param)
  call s:RunTest({-> 'call test#run("", ["' . a:param . '"])'})
endfunction

function! js#RunTestFile(param)
  call s:RunTest({-> 'call test#run("file", ["' . a:param . '"])'})
endfunction

function! js#RunTestLine()
  call s:RunTest({-> 'TestNearest'})
endfunction

function! js#RunTestDebug()
  normal! Odebugger;
  w
  call s:RunTest({-> 'TestNearest'}, {'prefix': ['node', '--inspect-brk']})
endfunction

function! js#RunTestsAll(param)
  call s:RunTest({-> 'call test#run("", ["' . a:param . '"])'}, {'project': 0})
endfunction

function! js#RunFlow()
  call util#Topen()
  let root = fnamemodify(findfile('.flowconfig', '.;'), ':.:h')
  execute ':T flow ' . root . ' --show-all-errors'
endfunction

function! js#RunGlow()
  call util#Topen()
  let root = fnamemodify(findfile('.flowconfig', '.;'), ':.:h')
  execute ':T pushd ' . root . '> /dev/null && glow -w && popd > /dev/null'
endfunction

function! js#OpenTestFile()
  let prefix = s:GetPrefix()
  for extension in ['.js', '.jsx']
    let file = prefix . '.test' . extension
    if util#TryOpenFile(file)
      return
    endif
  endfor
endfunction

function! js#OpenSnapshotFile()
  for extension in ['.js', '.jsx']
    let file = util#ExpandRelative('%:p:h') . '/__snapshots__/' . util#GetBaseFileName() . '.test' . extension . '.snap'
    if util#TryOpenFile(file)
      return
    endif
  endfor
endfunction

function! js#OpenCssFile()
  let prefix = s:GetPrefix()
  for extension in ['.css', '.scss', '.sass']
    let file = prefix . extension
    if util#TryOpenFile(file)
      return
    endif
  endfor
endfunction

function! js#RequireToImport()
  call util#Topen()
  execute ':T npm run update-require-to-import ' . util#ExpandRelative('%')
endfunction

function! js#OrganizeImports()
  call util#Topen()
  execute ':T npm run organize-imports ' . util#ExpandRelative('%')
endfunction

function! js#TypeConnect()
  call util#Topen()
  execute ':T npm run type-connect ' . util#ExpandRelative('%')
endfunction

function! js#FindFunction(command)
  execute 'normal! j?' . escape(s:js_function_regex, '?') . "\<CR>$V%" . a:command
endfunction

function! js#FindFunctionNext()
  let line_current = line('.')
  let line_function = search(s:js_function_regex)
  let line_class = search(s:js_class_regex)
  if line_current >= line_class && line_current < line_function
    call cursor(line_function, 0)
  endif
endfunction

function! js#FindFunctionPrevious()
  let line_current = line('.')
  let line_function = search(s:js_function_regex, 'b')
  let line_class = search(s:js_class_regex, 'b')

  if line_current <= line_class || line_current > line_function
    call cursor(line_function, 0)
  endif
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

function! js#FindProperty()
  execute "normal! /}\<CR>?\\v\\w+: \\{\<CR>$V%"
endfunction

function! js#FindTestCase(command)
  execute "normal! j?\\v^\\s+it\\('.+'\<CR>$V%" . a:command
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

function! js#ShowFlowCoverage()
  if exists('b:flow_coverage_status')
    echo b:flow_coverage_status
  endif
endfunction

function! js#NewTestFile()
  let file_name = util#GetBaseFileName()
  let test_file = expand('%:p:h') . '/' . file_name . '.test.' . expand('%:e')

  if !util#TryOpenFile(test_file)
    exec 'edit ' . test_file
    normal intf,e
  endif
endfunction

function! js#ShowError() abort
  if !exists('g:shell_prompt')
    echohl ErrorMsg
    echo 'Please set g:shell_prompt first'
    echohl None
    return
  endif

  let neoterm_win_id = util#get_neoterm_window()
  if !neoterm_win_id
    return
  endif

  let origin_win_id = win_getid()
  call win_gotoid(neoterm_win_id)
  normal! Gzb

  call search('\v' . g:shell_prompt, 'b')
  if search('\v● ', 'W')
    " jest error
    call s:FindError({
          \ 'pattern': '\v\(\_S*:\_d+:\_d+\)',
          \ 'origin_win_id': origin_win_id,
          \ 'cmd': 'normal! "xyib'
          \ })
  elseif search('\v^Error ┈+', 'W')
    " flow error
    call s:FindError({
          \ 'pattern': '\v^Error ┈+ ?\n?\zs\_S+:\_d+:\_d+',
          \ 'origin_win_id': origin_win_id,
          \ 'cmd': 'normal! "xy}'
          \ })
  elseif getline(1) =~ '\vGlow v.*'
    " glow error
    normal! gg
    call s:FindError({
          \ 'pattern': '\v\zs\_S+:\_d+',
          \ 'origin_win_id': origin_win_id,
          \ 'cmd': 'normal! "xy/\v:\d+'
          \ })
  else
    normal! Gzb
    echohl ErrorMsg
    echo 'No error found'
    echohl None
  endif

  call win_gotoid(origin_win_id)
endfunction

function! s:FindError(options)
  let options = a:options
  normal! zt
  let lnum = line('.')

  if search(options.pattern, 'c')
    execute options.cmd
    execute lnum
    normal! zt

    call win_gotoid(options.origin_win_id)
    let [path, line; rest] = split(fnamemodify(join(split(@x), ''), ':.'), ':')
    execute 'edit ' . path
    execute line
  endif
endfunction

function! js#GenProtobuf()
  call util#Topen()
  execute ':T ./pants gen-protobuf-javascript protobuf/src::'
endfunction

function! SendFileToTern(...)
  silent! py3 tern_sendBuffer()
endfunction

function! js#SendFileToTern()
  if has('timers')
    call timer_start(100, 'SendFileToTern')
  else
    call SendFileToTern()
  endif
endfunction

function! js#SetPath()
  let config = fnamemodify(findfile('BUILD', '.;'), ':.:h')
  if len(config)
    execute 'setlocal path+=' . config
  endif
endfunction

function! js#GoToDefinition()
  let current_pos = getpos('.')
  silent! LspDefinition
  if getpos('.') == current_pos
    silent! TernDef
  endif
endfunction
