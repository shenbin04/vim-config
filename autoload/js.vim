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
  normal! $
  call search(s:js_function_regex, 'bc')

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
  normal! $
  call search('\v\{', 'bc')
  normal V%
endfunction

function! js#FindTestCase(cmd)
  normal! $
  call search('\v\s*it\(', 'bc')
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

function! s:hash(str) abort
  let hash = 1
  for c in split(a:str, '\zs')
    let hash = (hash * 31 + char2nr(c)) % 2147483647
  endfor
  return hash
endfunction

function! s:SortObjectLine(line) abort
  let line = a:line
  if line !~ '\v\{.*(:|,).*\}'
    return line
  endif

  let result = s:SortObjectLineHelper(line)

  let placeholder = result.placeholder
  for lookup in result.lookup
    let placeholder = substitute(placeholder, '\V' . lookup.hash, '{' . lookup.content . '}', '')
  endfor

  return placeholder
endfunction

function! s:SortObjectLineHelper(line) abort
  let placeholder = a:line
  let lookup = []

  for object in s:GetObjectsFromLine(a:line)
    let hash = s:hash(object)
    let result = s:SortObjectLineHelper(object)
    let placeholder = substitute(placeholder, '\V{' . object . '}', hash, '')
    call insert(lookup, {'hash': hash, 'content': result.placeholder})
    call extend(lookup, result.lookup)
  endfor

  let placeholder_sorted = join(sort(split(placeholder, '\v, ?\ze\w+')), ', ')
  return {'placeholder': placeholder_sorted, 'lookup': lookup}
endfunction

function! s:GetObjectsFromLine(line) abort
  let level = 0
  let results = []

  let result = ''

  for c in split(a:line, '\zs')
    if c == '{'
      let level += 1
      let result .= c
    elseif c == '}'
      let level -= 1

      if level == 0
        call add(results, result[1:-1])
        let result = ''
      else
        let result .= c
      endif
    else
      if level > 0
        let result .= c
      endif
    endif
  endfor

  return results
endfunction

function! s:SortObjectLines(lines, start) abort
  let lines = a:lines
  let index = a:start

  let lines_to_sort = []
  let lines_sorted = {}

  while index < len(lines)
    let line = lines[index]

    if line =~ '\v(\=\>.*)@<!\{\|?$'
      let [sorted, index_current] = s:SortObjectLines(lines, index + 1)
      call insert(sorted, line)
      call add(sorted, lines[index_current])
      let lines_sorted[line] = sorted

      call add(lines_to_sort, line)

      let index = index_current
    elseif line =~ '\v^\s*\|?\}'
      call sort(lines_to_sort)
      break
    elseif line =~ '\v\{.*\}'
      let line_sorted = s:SortObjectLine(line)
      call add(lines_to_sort, line_sorted)
    else
      call add(lines_to_sort, line)

      let lines_no_sort = [line]
      let line_next = index + 1 < len(lines) ? lines[index + 1] : ''
      while len(line_next) && line_next !~ '\v(\}|\w+:|\w+,)'
        call add(lines_no_sort, line_next)
        let index += 1
        let line_next = index + 1 < len(lines) ? lines[index + 1] : ''
      endwhile

      if len(lines_no_sort) > 1
        let lines_sorted[line] = lines_no_sort
      endif
    endif

    let index += 1
  endw

  let sorted = []
  for line in lines_to_sort
    let sorted_for_line = get(lines_sorted, line, '')
    if len(sorted_for_line)
      call extend(sorted, sorted_for_line)
    else
      call add(sorted, line)
    endif
  endfor

  return [sorted, index]
endfunction

function! js#FormatObjectSort()
  let initial_pos = getpos('.')
  let lnum_original = line('.')

  normal! $
  call search('\v\{', 'bc')

  let lnum_start = line('.')

  normal! %
  let lnum_end = line('.')

  let lines = getline(lnum_start, lnum_end)

  let result = s:SortObjectLines(lines, 0)

  call setline(lnum_start, result[0])

  call setpos('.', initial_pos)
endfunction

function! js#FormatJsxSort()
  let initial_pos = getpos('.')

  let line = getline('.')

  if line =~# s:js_jsx_open_tag_regex
    let [_, indent, variable, jsx_tag, prop, end_tag, trailing; rest] = matchlist(line, s:js_jsx_open_tag_regex)
    let props = join(sort(split(prop, '[}"]\zs ')), ' ')
    call setline('.', indent . variable . jsx_tag . ' ' . props . end_tag . trailing)
  else
    normal! $
    let lnum = search('\v^\s*\<\w+', 'bc') + 1
    let lnum_start = lnum
    let line = getline(lnum)

    let lines_to_sort = []
    let lines_sorted = {}

    while lnum <= line('$') && line !~ '\v\s*(\/)?\>$'
      call add(lines_to_sort, line)

      let line_next = getline(lnum + 1)
      let lines_no_sort = [line]
      while lnum <= line('$') && line_next !~ '\v\s*\w+\=' && line_next !~ '\v\s*(\/)?\>$'
        call add(lines_no_sort, line_next)
        let lnum += 1
        let line_next = getline(lnum + 1)
      endwhile

      if len(lines_no_sort) > 1
        let lines_sorted[lines_no_sort[0]] = lines_no_sort
      endif

      let lnum += 1
      let line = getline(lnum)
    endwhile

    call sort(lines_to_sort)

    let sorted = []
    for line in lines_to_sort
      let sorted_for_line = get(lines_sorted, line, '')
      if len(sorted_for_line)
        call extend(sorted, sorted_for_line)
      else
        call add(sorted, line)
      endif
    endfor

    call setline(lnum_start, sorted)
  endif

  call setpos('.', initial_pos)
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
