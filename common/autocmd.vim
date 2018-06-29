autocmd BufWritePost .vimrc,vimrc source $MYVIMRC
autocmd BufWritePost *.vim source %

autocmd BufEnter * call util#CloseLastWindow()

" When opening a file, always jump to the last cursor position
autocmd BufReadPost *
      \ if line("'\"") > 0 && line ("'\"") <= line("$") |
      \     exe "normal! g'\"zz" |
      \ endif |

autocmd CursorHold * silent! checktime

autocmd QuickFixCmdPost * botright copen
autocmd FileType qf wincmd J

autocmd BufWinLeave ?* call util#SaveView()
autocmd BufWinEnter ?* silent! loadview
