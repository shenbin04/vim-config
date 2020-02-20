let s:js_function_regex = '\v^  \w+(\(.*\)(: \w+)? \{|(: \w+)? \= \(.*\)(: \w+)? \=\> (\{|.+;))$'
let s:js_class_regex = '\v^(export )?class \w+ extends .*$'
let s:js_object_regex = '\v\{\zs.+\ze\}.*'
let s:js_jsx_tag_regex = '\v^(\s*)(.*)(\<(\S+)[^>]*\>)(.*)(\<\/\4\>)(;?)$'
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
      return fnamemodify(root, ':~:.:h')
    endif
  endfor
endfunction

function! s:FindJest(...)
  let options = a:0 > 0 ? a:1 : {}
  let root = s:FindRoot()

  let cmd = ''

  if root != '.'
    let g:test#javascript#jest#should_pop = 1
    let cmd = 'pushd ' . root . ' > /dev/null && '
    execute 'cd '. root
  endif

  let cmd .= 'NODE_ENV=testing NODE_PATH=. ' . get(options, 'prefix', '') . 'node_modules/.bin/jest'
  if get(options, 'project', 1)
    let cmd .= ' --projects ' . fnamemodify(findfile('jest.config.js', '.;'), ':~:.:h')
  endif
  if !exists('g:test#javascript#jest#cache')
    let g:test#javascript#jest#cache = 1
  endif
  if !g:test#javascript#jest#cache
    let cmd .= ' --no-cache'
  endif
  let g:test#javascript#jest#executable = cmd
endfunction

function! s:MaybePop()
  if exists('g:test#javascript#jest#should_pop') && g:test#javascript#jest#should_pop
    let g:test#javascript#jest#should_pop = 0
    execute 'T popd > /dev/null'
    execute 'cd -'
  endif
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
  call util#Topen()
  call s:FindJest(options)
  execute a:1()
  call s:MaybePop()
endfunction

function! js#RunTestsInProject(param)
  call s:RunTest({-> 'T ' . g:test#javascript#jest#executable . ' ' . a:param})
endfunction

function! js#RunTestFile()
  call s:RunTest({-> 'TestFile' . s:GetCoverage()})
endfunction

function! js#RunTestUpdate()
  call s:RunTest({-> 'TestFile' . s:GetCoverage() . ' -u'})
endfunction

function! js#RunTestWatch()
  call s:RunTest({-> 'TestFile' . s:GetCoverage() . ' --watch'})
endfunction

function! js#RunTestLine()
  call s:RunTest({-> 'TestNearest'})
endfunction

function! js#RunTestDebug()
  normal! Odebugger;
  w
  call s:RunTest({-> 'TestNearest'}, {'prefix': 'node --inspect-brk '})
endfunction

function! js#RunTestsAll(param)
  call s:RunTest({-> 'T ' . g:test#javascript#jest#executable . ' ' . a:param}, {'project': 0})
endfunction

function! js#RunTestOnly()
  call s:RunTest({-> 'T ' . g:test#javascript#jest#executable . ' -o'})
endfunction

function! js#RunFlow()
  let root = fnamemodify(findfile('.flowconfig', '.;'), ':~:.:h')
  call util#Topen()
  execute ':T flow ' . root . ' --show-all-errors'
endfunction

function! js#RunGlow()
  let root = fnamemodify(findfile('.flowconfig', '.;'), ':p:h')
  call util#Topen()
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

  call search('\v' . xolox#misc#escape#substitute(g:shell_prompt), 'b')
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
    let [path, line; rest] = split(fnamemodify(join(split(@x), ''), ':~:.'), ':')
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
  let config = fnamemodify(findfile('BUILD', '.;'), ':~:.:h')
  if len(config)
    execute 'setlocal path+=' . config
  endif
endfunction
