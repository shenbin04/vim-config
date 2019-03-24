function! prettier#Prettier(...) range
  let l:cmd = 'prettier --range-start ' . util#GetCharOffset(a:firstline)
        \ . ' --range-end ' . (a:lastline > a:firstline ? util#GetCharOffset(a:lastline) : util#GetCharOffset(a:lastline + 1) - 1)
        \ . ' ' . expand('%')
  let l:formatted_text = systemlist(l:cmd)

  if v:shell_error
    echohl ErrorMsg
    echomsg printf('"%s" returned error: %s', l:cmd, l:formatted_text[-1])
    echohl None
    return
  endif

  execute a:firstline . ',' . string(line('$')) . 'delete'
  call setline(1, l:formatted_text)

  call cursor(a:firstline, 1)
endfunction
