function! util#TryOpenFile(file, message)
  if filereadable(a:file)
    if util#ExpandRelative('%:p') != a:file
      exe 'edit ' . a:file
    endif
    return 1
  else
    return 0
  endif
endfunction

function! util#ExpandRelative(pattern)
  return fnamemodify(expand(a:pattern), ':~:.')
endfunction

function! util#CloseLastWindow()
  if &buftype == 'quickfix' || &buftype == 'nofile'
    if winbufnr(2) == -1
      quit!
    endif
  endif
endfunction
