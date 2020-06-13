let s:js_object_regex = '\v\{\zs.+\ze\}.*'
let s:js_function_regex = '\v('
      \ . '^(export )?\s*function \zs\w+'
      \ . '|^(export )?\s*const \zs\w+ \= \('
      \ . '|^(export )?\s*class \zs\w+ extends'
      \ . '|^  \zs\w+ \= \('
      \ . '|^  \zs\w+\(.*\{'
      \ . ')'
let s:js_jsx_open_tag_regex = '\v^(\s*)(.*)(\<\S+) (.{-1,})( ?/{,1}\>)(.*)'

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
    call util#EchoError('Please run tests in project root.')
    return
  endif

  let g:test#javascript#jest#prefix = ['NODE_ENV=testing', 'NODE_PATH=.'] + get(options, 'prefix', [])
  let g:test#javascript#jest#project = get(options, 'project', 1)
  let g:test#javascript#jest#options = []
  let g:test#javascript#jest#coverage = 0

  let project_coverage = get(g:, 'test#javascript#jest#project_coverage', 0)
  if project_coverage
    let g:test#javascript#jest#coverage = 1
    let project = util#FindProject()
    if project != '.'
      let g:test#javascript#jest#options = ['--collectCoverageFrom', string(project . '/**/*.{js,jsx}')]
    endif
  endif

  let file_coverage = get(options, 'file_coverage', 0)
  if file_coverage
    let g:test#javascript#jest#coverage = 1
    let g:test#javascript#jest#options = ['--collectCoverageFrom', js#GetJSFileFromTestFile()]
  endif

  return 1
endfunction

function! js#GetJSFileFromTestFile()
  return util#ExpandRelative('%:p:h') . '/' . util#GetBaseFileName() . '.' . expand('%:e')
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
  call s:RunTest({-> 'call test#run("file", ["' . a:param . '"])'}, {'file_coverage': 1})
endfunction

function! js#RunTestLine()
  call s:RunTest({-> 'TestNearest'})
endfunction

function! js#RunTestDebug()
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

function! js#FindFunction(cmd)
  normal j
  call search(s:js_function_regex, 'b')

  let line = getline('.') 

  normal $V%
  if line !~ '\v(function|\=\>)'
    normal $%
  endif

  if len(a:cmd)
    execute 'normal! ' . a:cmd
  endif
endfunction

function! js#FindProperty()
  normal j
  call search('\v\{', 'b')
  normal V%
endfunction

function! js#FindTestCase(cmd)
  normal j
  call search('\v\s*it\(', 'b')
  normal V%

  if len(a:cmd)
    execute 'normal! ' . a:cmd
  endif
endfunction

function! js#FindFunctionNext()
  call search(s:js_function_regex)
endfunction

function! js#FindFunctionPrevious()
  call search(s:js_function_regex, 'b')
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

function! js#NewTestFile(snippet)
  let file_name = util#GetBaseFileName()
  let test_file = expand('%:p:h') . '/' . file_name . '.test.' . expand('%:e')

  if !util#TryOpenFile(test_file)
    execute 'edit ' . test_file
    execute 'normal i' . a:snippet . ',e'
  endif
endfunction

function! js#NewScssFile()
  normal ons,e
  w

  let file_name = util#GetBaseFileName()
  let scss_file = expand('%:p:h') . '/' . file_name . '.scss'

  if !util#TryOpenFile(scss_file)
    execute 'edit ' . scss_file
    w
  endif
endfunction

function! js#ShowError() abort
  if !exists('g:shell_prompt')
    call util#EchoError('Please set g:shell_prompt first.')
    return
  endif

  let neoterm_win_id = util#GetNeotermWindow()
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
    call util#EchoError('No error found.')
  endif

  call win_gotoid(origin_win_id)
endfunction

function! s:FindError(options)
  let options = a:options
  normal! zt
  let lnum = line('.')

  while search(options.pattern)
    execute options.cmd
    let position = fnamemodify(join(split(@x), ''), ':.')
    if position !~ '^node_modules'
      execute lnum
      normal! zt

      call win_gotoid(options.origin_win_id)
      let [path, line; rest] = split(fnamemodify(join(split(@x), ''), ':.'), ':')
      if filereadable(path)
        execute 'edit ' . path
        execute line
      endif

      break
    endif
  endwhile
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

function! js#GoToDefinition()
  let initial_pos = getpos('.')
  let initial_buf = bufnr('%')

  let current_pos = initial_pos
  silent! TernDef
  while getpos('.') != current_pos
    let current_pos = getpos('.')
    silent! TernDef
  endwhile
  let current_pos = getpos('.')

  if current_pos == initial_pos || (bufnr('%') == initial_buf && getline('.')[col('.') - 1] =~ '\W')
    call setpos('.', initial_pos)
    silent! LspDefinition
  endif
endfunction
