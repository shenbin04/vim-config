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
  tnoremap <buffer> <silent> <C-g> <C-\><C-n>:call <SID>PrepareFZFSwitch()<CR>:call fzf#vim#gitfiles('.', fzf#vim#with_preview({'options': ['--query', g:fzf_query]}, g:fzf_preview_window), 1)<CR>
  tnoremap <buffer> <silent> <C-h> <C-\><C-n>:call <SID>PrepareFZFSwitch()<CR>:call fzf#vim#history(fzf#vim#with_preview({'options': ['--query', g:fzf_query]}, g:fzf_preview_window), 1)<CR>
  tnoremap <buffer> <silent> <C-b> <C-\><C-n>:call <SID>PrepareFZFSwitch()<CR>:call fzf#vim#buffers('.', fzf#vim#with_preview({'options': ['--query', g:fzf_query]}, g:fzf_preview_window), 1)<CR>
  tnoremap <buffer> <silent> <C-c> <C-\><C-n>:call <SID>PrepareFZFSwitch()<CR>:call fzf#vim#gitfiles(expand('%:h'), fzf#vim#with_preview({'options': ['--query', g:fzf_query, '--prompt', 'Dir> ']}, g:fzf_preview_window), 1)<CR>
  tnoremap <buffer> <silent> <C-a> <C-\><C-n>:call <SID>PrepareFZFSwitch()<CR>:call fzf#vim#files('.', fzf#vim#with_preview({'options': ['--query', g:fzf_query, '--prompt', 'Dir All> ']}, g:fzf_preview_window), 1)<CR>
endfunction

function! s:ConfigNeoTerm()
  setlocal nocursorline nocursorcolumn
  tnoremap <buffer> <Leader><ESC> <C-\><C-n>
  tnoremap <buffer> <C-h> <C-\><C-n>:TmuxNavigateLeft<CR>
  tnoremap <buffer> <C-j> <C-\><C-n>:TmuxNavigateDown<CR>
  tnoremap <buffer> <C-k> <C-\><C-n>:TmuxNavigateUp<CR>
  tnoremap <buffer> <C-l> <C-\><C-n>:TmuxNavigateRight<CR>
  tnoremap <buffer> <C-\> <C-\><C-n>:TmuxNavigatePrevious<CR>
endfunction
