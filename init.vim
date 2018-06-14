set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

set inccommand=nosplit

tnoremap <Leader><ESC> <C-\><C-n>

tnoremap <C-h> <C-\><C-n><C-w>h:call util#MaybeInsertMode()<CR>
tnoremap <C-j> <C-\><C-n><C-w>j:call util#MaybeInsertMode()<CR>
tnoremap <C-k> <C-\><C-n><C-w>k:call util#MaybeInsertMode()<CR>
tnoremap <C-l> <C-\><C-n><C-w>l:call util#MaybeInsertMode()<CR>

autocmd TermOpen * startinsert
autocmd BufWinEnter,WinEnter term://* startinsert
