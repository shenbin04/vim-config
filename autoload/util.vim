function! util#TryOpenFile(file, message)
  if filereadable(a:file)
    if util#ExpandRelative('%:p') != a:file
      exe 'edit ' . a:file
    endif
    return 1
  else
    " echo a:message
    return 0
  endif
endfunction

function! util#ExpandRelative(pattern)
  return fnamemodify(expand(a:pattern), ':~:.')
endfunction
