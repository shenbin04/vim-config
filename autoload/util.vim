function! util#TryOpenFile(file)
  if filereadable(a:file)
    if util#ExpandRelative('%:p') != a:file
      exe 'edit ' . a:file
    endif
    return 1
  else
    return 0
  endif
endfunction

function! util#GetBaseFileName()
  return split(expand('%:t:r'), '\.')[0]
endfunction

function! util#ExpandRelative(pattern)
  return fnamemodify(expand(a:pattern), ':.')
endfunction

function! util#ExpandToGit(from)
  return fnamemodify(finddir('.git', a:from . ';'), ':h')
endfunction

function! util#ExpandRelativeToGit(pattern)
  return xolox#misc#path#relative(expand(a:pattern), fnamemodify(util#ExpandToGit('.'), ':p'))
endfunction

function! util#CloseLastWindow()
  if &buftype == 'quickfix'
    if winbufnr(2) == -1
      quit!
    endif
  endif
endfunction

function! util#Zoom()
  if winnr('$') == 1 && len(gettabinfo()) > 1
    q
  elseif winnr('$') > 1
    tab split
  endif
endfunction

function! util#SaveView()
  if expand('%') != '' && &buftype != 'terminal' && &buftype != 'nofile'
    mkview
  endif
endfunction

function! util#LoadView()
  if expand('%') != '' && &buftype != 'terminal' && &buftype != 'nofile'
    silent! loadview
  endif
endfunction

function! util#SelectBetweenPattern(pattern)
  let line = getline('.')
  if line !~ a:pattern
    let start = search(a:pattern, 'bW')
    if !start
      return
    end
  endif
  let current = line('.')
  let next = search(a:pattern, 'W')
  if next > current
    let end = next - 1
  elseif next == 0
    let end = line('$')
  else
    let end = current
  endif
  execute "normal! " . current . "GV" . end . "G"
endfunction

function! util#SetReg(regs, message)
  for reg in a:regs
    execute 'let @' . reg. '="' . a:message . '"'
  endfor
  echo 'Copied: ' . a:message
endfunction

function! util#MaybeInsertMode()
  if &buftype == 'terminal'
    startinsert
  endif
endfunction

function! util#OpenHtml() range
  let g:html_use_css = 0
  let g:html_number_lines = 0
  execute a:firstline . ',' a:lastline . 'TOhtml'
  unlet g:html_number_lines
  execute 'sav ' . xolox#misc#path#tempdir() . '/' . expand('%:t')
  silent !open %:p
  bd!
endfunction

function! util#OpenStash() range
  if !exists('g:stash_url')
    echo 'Please set g:stash_url first'
    return
  endif
  let top = a:firstline
  let bot = a:lastline
  let path = g:stash_url . util#ExpandRelativeToGit('%:p') . '\#' . top
  if bot > top
    let path = path . '-' . bot
  endif
  let @+ = xolox#misc#str#unescape(path)
  silent execute '!open ' . path
endfunction

function! util#OpenDiffusion() range abort
  if !exists('g:diffusion_url')
    echo 'Please set g:diffusion_url first'
    return
  endif
  let top = a:firstline
  let bot = a:lastline

  let path = g:diffusion_url . util#ExpandRelativeToGit('%:p')

  let branch = system('git rev-parse --abbrev-ref HEAD')[0:-2]
  if branch == 'master'
    let hash = system('git rev-parse --verify HEAD')[0:-2]
    let path = path . '\;' . hash
  endif

  let path = path . '\$' . top
  if bot > top
    let path = path . '-' . bot
  endif

  let @+ = xolox#misc#str#unescape(path)
  silent execute '!open ' . path
endfunction

function! util#yapfOperator(type, ...)
  if a:type ==# 'line'
    let line_start = getpos("'[")[1]
    let line_end = getpos("']")[1]
    silent execute line_start . ',' . line_end . 'call yapf#YAPF()'
  endif
endfunction

function! util#GetCharOffset(line)
  return len(join(getline(0, a:line)[:-2], ' '))
endfunction

function! util#ClearHighlight()
  if exists('g:plugs["jedi-vim"]')
    call jedi#clear_usages()
  endif
endfunction

function! util#GitDiff(target)
  if expand('%') ==# ''
    return
  endif
  execute 'Gdiffsplit ' . a:target
  call s:SetDiffBufferSyntax('diff')
endfunction

function! util#GitDiffEnd()
  if len(s:GetDiffBuffers()) == 2
    call s:SetDiffBufferSyntax('on')
  endif
endfunction

function! util#OpenFugitive()
  let fugitive_win_nr = util#GetWinNrByFt('fugitive')
  if !fugitive_win_nr
    10split
  endif
endfunction

function! util#CloseFugitive()
  let fugitive_win_nr = util#GetWinNrByFt('fugitive')
  if fugitive_win_nr
    execute 'bd ' . winbufnr(fugitive_win_nr)
  endif
endfunction

function! util#CloseDiff()
  let diff_buffers = s:GetDiffBuffers()
  for bufnr in diff_buffers
    execute 'bd' . bufnr
  endfor
endfunction

function! s:SetDiffBufferSyntax(syntax) abort
  for nr in range(1, winnr('$'))
    if getwinvar(nr, '&diff')
      call setbufvar(winbufnr(nr), '&syntax', a:syntax)
    endif
  endfor
endfunction

function! s:GetDiffBuffers() abort
  let diff_buffers = []
  for nr in range(1, winnr('$'))
    if getwinvar(nr, '&diff')
      call add(diff_buffers, winbufnr(nr))
    endif
  endfor
  return diff_buffers
endfunction

function! util#GetWinNrByFt(filetype) abort
  for nr in range(1, winnr('$'))
    if getwinvar(nr, '&filetype') ==# a:filetype
      return nr
    endif
  endfor
endfunction

function! util#GetNeotermWindow() abort
  let neoterm_win_nr = util#GetWinNrByFt('neoterm')
  if neoterm_win_nr
    return win_getid(neoterm_win_nr)
  endif
endfunction

function! util#NeotermResize() abort
  let neoterm_win_nr = util#GetWinNrByFt('neoterm')
  if !neoterm_win_nr
    return
  endif

  silent! execute join(map(['>', '<', '-', '+'], {_, val -> neoterm_win_nr . 'wincmd ' . val}), ' | ')
endfunction

function! util#ToggleFlag(flag) abort
  let name = a:flag.name
  let default = a:flag.default
  let value = a:flag.value

  if !exists(name)
    execute 'let ' . name . ' = ' . string(default)
  endif
  execute 'let ' . name . ' = ' name . ' == ' . string(default) . '? ' . string(value) . ' : ' . string(default)

  let Callback = get(a:flag, 'callback')
  if !empty(Callback) && type(Callback) == v:t_func
    call Callback()
  endif

  execute 'echo "[ToggleFlag] ' . name . ' = " . string(' . name . ')'
endfunction

function! util#GetSearchCmd() abort
  if !exists('g:search#use_fzf')
    return 'Ag!'
  endif
  return g:search#use_fzf ? 'Ag!' : 'GrepperAg'
endfunction

function! util#GrepByWord(by_word, path)
  let boundary = a:by_word ? "\\b" : ""
  let cmd = util#GetSearchCmd() . " \"" . boundary . @w . boundary . "\" " . a:path
  execute "normal! :" . cmd . "\<CR>"
  call histadd('cmd', cmd)
endfunction

function! util#ag(args, bang)
  let quote_query_match = matchlist(a:args, '\v([''"].*[''"]) ?(.*)')

  if !empty(quote_query_match)
    let args = split(quote_query_match[2])
    call insert(args, quote_query_match[1])
  else
    let args = split(a:args)
  endif

  let dir = ''

  let i = 0
  if len(args) >= 2
    while i < len(args) - 1 && args[i + 1][0] != '-'
      let i = i + 1
      let dir = args[i]
    endwhile
  endif

  let options = {}
  if !empty(dir)
    let options.dir = dir
    let options.options = '--prompt Ag[' . dir . ']'
    unlet args[i]
  endif

  call fzf#vim#ag_raw(join(args), fzf#vim#with_preview(options, g:fzf_preview_window), a:bang)
endfunction

function! util#Topen()
  call util#CloseDiff()
  Topen
endfunction

function! util#OpenOwnersFile()
  let file = findfile('OWNERS', '.;')
  call util#TryOpenFile(file)
endfunction

function! util#FindProject()
  for file in ['.project', '.flowconfig', 'webpack.config.js', 'jest.config.js']
    let path = findfile(file, '.;' . getcwd())
    if len(path)
      return fnamemodify(path, ':~:.:h')
    endif
  endfor

  let git_dir = finddir('.git', '.;' . getcwd())
  if len(git_dir)
    return fnamemodify(git_dir, ':h')
  endif

  return '.'
endfunction

function! util#EditProject()
  execute 'Files! ' . util#FindProject()
endfunction

function! util#RenameFile()
  let current_file = expand('%:p')
  let name = input('Rename ' . expand('%:t') . ' to: ', current_file)
  if !empty(name)
    execute 'saveas ' . name
    call delete(current_file)
  endif
endfunction

function! util#ListAllBuffers()
  for buf in range(1, bufnr('$'))
    if !bufexists(buf)
      continue
    endif
    echo '[' . buf . '] ' . bufname(buf)
  endfor
endfunction

function! util#EchoError(message)
  echohl ErrorMsg
  echom a:message
  echohl None
endfunction
