set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

set inccommand=nosplit

tnoremap <Leader><ESC> <C-\><C-n>

tnoremap <C-h> <C-\><C-n><C-w>h:call util#MaybeInsertMode()<CR>
tnoremap <C-j> <C-\><C-n><C-w>j:call util#MaybeInsertMode()<CR>
tnoremap <C-k> <C-\><C-n><C-w>k:call util#MaybeInsertMode()<CR>
tnoremap <C-l> <C-\><C-n><C-w>l:call util#MaybeInsertMode()<CR>

function! s:MaybeInsertModeForTerminal()
  let file = expand('%')
  if file =~ 'git '
    startinsert
  endif
endfunction

function! PrepareFZFSwitch()
  let @s=matchstr(getline('.'), '\v\> ?\zs.+\ze$')
  close
  sleep 1m
endfunction

autocmd TermOpen * call s:MaybeInsertModeForTerminal()
autocmd BufWinEnter,WinEnter term://* call s:MaybeInsertModeForTerminal()
autocmd FileType fzf tnoremap <buffer> <C-k> <Up>|
      \ tnoremap <buffer> <C-j> <Down>|
      \ tnoremap <C-g> <C-\><C-n>:call PrepareFZFSwitch()<CR>:call fzf#vim#gitfiles('.', {'options': ['--query', @s]})<CR>|
      \ tnoremap <C-h> <C-\><C-n>:call PrepareFZFSwitch()<CR>:call fzf#vim#history({'options': ['--query', @s]})<CR>|
      \ tnoremap <C-b> <C-\><C-n>:call PrepareFZFSwitch()<CR>:call fzf#vim#buffers('.', {'options': ['--query', @s]})<CR>|
      \ tnoremap <C-c> <C-\><C-n>:call PrepareFZFSwitch()<CR>:call fzf#vim#gitfiles(expand('%:h'), {'options': ['--query', @s, '--prompt', 'Dir> ']})<CR>|
      \ tnoremap <C-a> <C-\><C-n>:call PrepareFZFSwitch()<CR>:call fzf#vim#files(expand('%:h'), {'options': ['--query', @s, '--prompt', 'Dir All> ']})<CR>
autocmd FileType neoterm setlocal nocursorline nocursorcolumn

hi link TermCursorNC Cursor
