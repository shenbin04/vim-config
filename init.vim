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
  if file =~ 'git add --patch'
    startinsert
  endif
endfunction

autocmd TermOpen * call s:MaybeInsertModeForTerminal()
autocmd BufWinEnter,WinEnter term://* call s:MaybeInsertModeForTerminal()
autocmd FileType fzf tnoremap <buffer> <C-k> <Up>|tnoremap <buffer> <C-j> <Down>

hi link TermCursorNC Cursor
