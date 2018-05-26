autocmd BufEnter * call util#CloseLastWindow()

autocmd BufWritePost .vimrc,vimrc,$HOME/.vim/common/** source $MYVIMRC

if has('nvim')
  autocmd TermOpen * startinsert
endif

" When opening a file, always jump to the last cursor position
autocmd BufReadPost *
      \ if line("'\"") > 0 && line ("'\"") <= line("$") |
      \     exe "normal! g'\"zz" |
      \ endif |

autocmd CursorHold * silent! checktime

autocmd QuickFixCmdPost * botright copen
autocmd FileType qf wincmd J
