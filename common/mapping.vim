let g:mapleader = ','

" Buffer
nnoremap _ :split<CR>
nnoremap \| :vsplit<CR>
nnoremap <Leader>ch :helpclose<CR>
nnoremap <Leader>cq :cclose<CR>
nnoremap <Leader>cp :pclose<CR>
nnoremap <silent> <Leader>cw :cclose<CR>:pclose<CR>:helpclose<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>1 :BufSurfBack<CR>
nnoremap <Leader>2 :BufSurfForward<CR>
nnoremap <Leader>3 :b#<CR>

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
nnoremap <silent> <Leader>x :noh<CR>

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
nnoremap <silent> <leader>cc "+y
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

" Open Stash
noremap <silent> <Leader>os :call util#OpenStash()<CR>

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
