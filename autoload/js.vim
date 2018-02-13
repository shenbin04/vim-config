function! GetPrefix()
  let dir = split(util#ExpandRelative('%:p:h'), '/')
  let base = join(dir[0:dir[-1] == '__snapshots__' ? -2 : -1], '/')
  return base . '/' . split(expand('%:t:r'), '\.')[0]
endfunction

function! GetCoverage()
  return ' --coverage --collectCoverageFrom ' . js#GetJSFileFromTestFile()
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
  execute ':TestFile' . GetCoverage()
endfunction

function! js#RunTestWatch()
  execute ':TestFile' . GetCoverage() . ' --watch'
endfunction

function! js#RunTestDebug()
  let jest = test#javascript#jest#executable()
  let g:test#javascript#jest#executable = 'node debug ' . jest
  execute ':TestNearest'
  let g:test#javascript#jest#executable = jest
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

function! js#JSFunctionAction(command)
  execute "normal! " . "?\\v^\\s*[a-zA-Z]+( \\= )\\?\\(.*\\) (\\=\\> )\\?\\{\\?\\(\\?$\<CR>f{V%o" . a:command
endfunction

function! js#JSPropertyAction()
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
