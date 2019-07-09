let g:mapleader = ','

" Buffer
nnoremap _ :split<CR>
nnoremap \| :vsplit<CR>
nnoremap <silent> <Leader>ch :helpclose<CR>
nnoremap <silent> <Leader>cq :cclose<CR>
nnoremap <silent> <Leader>cl :lclose<CR>
nnoremap <silent> <Leader>cp :pclose<CR>
nnoremap <silent> <Leader>cf :call util#CloseFugitive()<CR>
nnoremap <silent> <Leader>cd :call util#CloseDiff()<CR>
nnoremap <silent> <Leader>co :cclose<CR>:pclose<CR>:helpclose<CR>:lclose<CR>:Tclose<CR>:call util#CloseFugitive()<CR>:call util#CloseDiff()<CR>
nnoremap <silent> <Leader>q :q<CR>
nnoremap <silent> <Leader>w :w<CR>
nnoremap <silent> <Leader>1 :BufSurfBack<CR>
nnoremap <silent> <Leader>2 :BufSurfForward<CR>
nnoremap <silent> <Leader>3 :b#<CR>

" Tab
nnoremap [t :tabprevious<CR>
nnoremap ]t :tabnext<CR>

" Window
nnoremap <silent> M :call util#zoom()<CR>
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <Leader>j <C-w>J
nnoremap <Leader>k <C-w>K
nnoremap <Leader>h <C-w>H
nnoremap <Leader>l <C-w>L
nnoremap <Up>    2<C-w>-
nnoremap <Down>  2<C-w>+
nnoremap <Left>  2<C-w><
nnoremap <Right> 2<C-w>>

" Move
nnoremap <expr> k (v:count > 1 ? "m'" . v:count : '') . 'gk'
nnoremap <expr> j (v:count > 1 ? "m'" . v:count : '') . 'gj'
nnoremap <expr> gk (v:count > 1 ? "m'" . v:count : '') . 'k'
nnoremap <expr> gj (v:count > 1 ? "m'" . v:count : '') . 'j'
nnoremap G Gzz
nnoremap n nzz
nnoremap N Nzz
nnoremap } }zz
nnoremap { {zz
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Search
nnoremap <Leader>s :%s/
nnoremap <Leader>S :%S/
vnoremap <Leader>s :S/
nnoremap & :&&<CR>
xnoremap & :&&<CR>
nnoremap <silent> <Leader>x :noh<CR>:call util#ClearHighlight()<CR>

" Diff
nnoremap <Leader>dg :diffget<CR>
vnoremap <Leader>dg :diffget<CR>
nnoremap <Leader>dp :diffput<CR>
vnoremap <Leader>dp :diffput<CR>

" Macro
vnoremap . :normal! .<CR>
vnoremap @ :normal! @

" Sort
vnoremap ss :sort<CR>
vnoremap su :sort -u<CR>

" Clipboard
nnoremap <silent> <Leader>y "+y
nnoremap <silent> <Leader>cs :call util#SetReg('+', expand('%:t'))<CR>
nnoremap <silent> <Leader>cr :call util#SetReg('+', util#ExpandRelative('%:p'))<CR>
nnoremap <silent> <Leader>cl :call util#SetReg('+', expand('%:p'))<CR>

" Between
onoremap <silent> i, :normal! t,vT,<CR>
vnoremap <silent> i, :normal! t,vT,<CR>
onoremap <silent> i$ :normal! t$vT$<CR>
vnoremap <silent> i$ :normal! t$vT$<CR>
onoremap <silent> i% :normal! t%vT%<CR>
vnoremap <silent> i% :normal! t%vT%<CR>
onoremap <silent> i^ :normal! t^vT^<CR>
vnoremap <silent> i^ :normal! t^vT^<CR>

" Open Source Code
noremap <silent> <Leader>od :call util#OpenDiffusion()<CR>
noremap <silent> <Leader>os :call util#OpenStash()<CR>

" Open Html
noremap <silent> <Leader>oh :call util#OpenHtml()<CR>

" Command-line
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Help
nnoremap gh :h <C-r><C-w><CR>

" Misc
nnoremap <Space> za
nnoremap gV `[v`]
nnoremap <C-b> :redraw!<CR>
nnoremap <F2> :setlocal spell!<CR>
nnoremap <Leader>cu :set cursorline! cursorcolumn!<CR>
nnoremap <Leader>ec :e $HOME/.vim/vimrc<CR>
inoremap jk <ESC>
inoremap <C-d> <Esc>ddi
inoremap <C-u> <Esc>lgUiwgi
