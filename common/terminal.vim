tnoremap <C-h> <C-\><C-n><C-w>h<CR>
tnoremap <C-j> <C-\><C-n><C-w>j<CR>
tnoremap <C-k> <C-\><C-n><C-w>k<CR>
tnoremap <C-l> <C-\><C-n><C-w>l<CR>

autocmd TermOpen * call s:OnTermOpen()
autocmd FileType fzf call s:ConfigFZFMapping()
autocmd FileType neoterm call s:ConfigNeoTerm()
autocmd BufWinEnter,WinEnter term://* call util#NeotermResize()

function! s:OnTermOpen()
  let bufname = bufname()

  if bufname =~ 'git '
    startinsert
  endif

  if bufname =~ 'bin/fzf'
    call util#CloseFugitive()
  endif
endfunction

function! s:PrepareFZFSwitch()
  let g:fzf_query=matchstr(getline('.'), '\v\> ?\zs.{-}\ze\s*(╰─*╯)?$')
  close
  sleep 1m
endfunction

function! s:ConfigFZFMapping()
  tnoremap <buffer> <C-k> <Up>
  tnoremap <buffer> <C-j> <Down>
  tnoremap <buffer> <C-g> <C-\><C-n>:silent! call <SID>PrepareFZFSwitch()<CR>:silent! call fzf#vim#gitfiles('.', fzf#vim#with_preview({'options': ['--query', g:fzf_query]}, g:fzf_preview_window), 1)<CR>
  tnoremap <buffer> <C-h> <C-\><C-n>:silent! call <SID>PrepareFZFSwitch()<CR>:silent! call fzf#vim#history(fzf#vim#with_preview({'options': ['--query', g:fzf_query]}, g:fzf_preview_window), 1)<CR>
  tnoremap <buffer> <C-b> <C-\><C-n>:silent! call <SID>PrepareFZFSwitch()<CR>:silent! call fzf#vim#buffers('.', fzf#vim#with_preview({'options': ['--query', g:fzf_query]}, g:fzf_preview_window), 1)<CR>
  tnoremap <buffer> <C-c> <C-\><C-n>:silent! call <SID>PrepareFZFSwitch()<CR>:silent! call fzf#vim#gitfiles(expand('%:h'), fzf#vim#with_preview({'options': ['--query', g:fzf_query, '--prompt', 'Dir> ']}, g:fzf_preview_window), 1)<CR>
  tnoremap <buffer> <C-a> <C-\><C-n>:silent! call <SID>PrepareFZFSwitch()<CR>:silent! call fzf#vim#files('.', fzf#vim#with_preview({'options': ['--query', g:fzf_query, '--prompt', 'Dir All> ']}, g:fzf_preview_window), 1)<CR>
endfunction

function! s:ConfigNeoTerm()
 setlocal nocursorline nocursorcolumn
 tnoremap <buffer> <Leader><ESC> <C-\><C-n>
endfunction
