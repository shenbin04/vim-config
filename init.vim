set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

set inccommand=nosplit

tnoremap <C-h> <C-\><C-n><C-w>h:call util#MaybeInsertMode()<CR>
tnoremap <C-j> <C-\><C-n><C-w>j:call util#MaybeInsertMode()<CR>
tnoremap <C-k> <C-\><C-n><C-w>k:call util#MaybeInsertMode()<CR>
tnoremap <C-l> <C-\><C-n><C-w>l:call util#MaybeInsertMode()<CR>

function! s:OnTermOpen()
  let bufname = bufname()

  if bufname =~ 'git '
    startinsert
  endif

  if bufname =~ 'bin/fzf'
    call util#CloseFugitive()
  endif
endfunction

function! PrepareFZFSwitch()
  let @s=matchstr(getline('.'), '\v\> ?\zs.{-}\ze\s*(╰─*╯)?$')
  close
  sleep 1m
endfunction

autocmd TermOpen * call s:OnTermOpen()
autocmd BufWinEnter,WinEnter term://* call util#NeotermResize()
autocmd FileType fzf tnoremap <buffer> <C-k> <Up>|
      \ tnoremap <buffer> <C-j> <Down>|
      \ tnoremap <buffer> <C-g> <C-\><C-n>:silent! call PrepareFZFSwitch()<CR>:call fzf#vim#gitfiles('.', fzf#vim#with_preview({'options': ['--query', @s]}, g:fzf_preview_window), 1)<CR>|
      \ tnoremap <buffer> <C-h> <C-\><C-n>:silent! call PrepareFZFSwitch()<CR>:call fzf#vim#history(fzf#vim#with_preview({'options': ['--query', @s]}, g:fzf_preview_window), 1)<CR>|
      \ tnoremap <buffer> <C-b> <C-\><C-n>:silent! call PrepareFZFSwitch()<CR>:call fzf#vim#buffers('.', fzf#vim#with_preview({'options': ['--query', @s]}, g:fzf_preview_window), 1)<CR>|
      \ tnoremap <buffer> <C-c> <C-\><C-n>:silent! call PrepareFZFSwitch()<CR>:call fzf#vim#gitfiles(expand('%:h'), fzf#vim#with_preview({'options': ['--query', @s, '--prompt', 'Dir> ']}, g:fzf_preview_window), 1)<CR>|
      \ tnoremap <buffer> <C-a> <C-\><C-n>:silent! call PrepareFZFSwitch()<CR>:call fzf#vim#files('.', fzf#vim#with_preview({'options': ['--query', @s, '--prompt', 'Dir All> ']}, g:fzf_preview_window), 1)<CR>
autocmd FileType neoterm setlocal nocursorline nocursorcolumn|
      \ tnoremap <buffer> <Leader><ESC> <C-\><C-n>

hi link TermCursorNC Cursor
