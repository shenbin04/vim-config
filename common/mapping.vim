let g:mapleader = ','
let g:localmapleader = ','

" Buffer
nnoremap _ :split<CR>
nnoremap \| :vsplit<CR>
nnoremap <Leader>ch :helpclose<CR>
nnoremap <Leader>cq :cclose<CR>
nnoremap <Leader>cp :pclose<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>1 :BufSurfBack<CR>
nnoremap <Leader>2 :BufSurfForward<CR>
nnoremap <Leader>3 :b#<CR>

" Window
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <Leader>J <C-w>J
nnoremap <Leader>K <C-w>K
nnoremap <Leader>H <C-w>H
nnoremap <Leader>L <C-w>L
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
nnoremap <C-D> <C-D>zz
nnoremap <C-U> <C-U>zz

" Search
nnoremap <Leader>s :%s/
nnoremap <Leader>S :%S/
vnoremap <Leader>s :S/
nnoremap & :&&<CR>
xnoremap & :&&<CR>
nnoremap <Leader>x :noh<CR>

" Ag
nnoremap <Leader>aa :GrepperAg 
nnoremap <Leader>aw "wyiw:GrepperAg "\b<C-R>w\b" 

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

" Vimux
nnoremap <Leader>rc :call VimuxCloseRunner()<CR>
nnoremap <Leader>ro :call VimuxOpenRunner()<CR>
nnoremap <Leader>rb :call VimuxInterruptRunner()<CR>
nnoremap <Leader>ra :call VimuxPromptCommand()<CR>
nnoremap <Leader>rm :call VimuxZoomRunner()<CR>

" Clipboard
nnoremap <leader>cc "+y
nnoremap <Leader>cs :let @+=expand('%:t')<CR>
nnoremap <Leader>cr :let @+=util#ExpandRelative('%:p')<CR>
nnoremap <Leader>cl :let @+=expand('%:p')<CR>

" Misc
nnoremap gV `[v`]
inoremap jk <ESC>
nnoremap <C-B> :redraw!<CR>
nnoremap <F2> :setlocal spell!<CR>
nnoremap <Leader>cu :set cursorline! cursorcolumn!<CR>
nnoremap <Leader>ec :e $HOME/.vim/vimrc<CR>
nnoremap <Space> za

" Between
onoremap <silent> i, :normal! t,vT,<CR>
vnoremap <silent> i, :normal! t,vT,<CR>
onoremap <silent> i$ :normal! t$vT$<CR>
vnoremap <silent> i$ :normal! t$vT$<CR>
onoremap <silent> i% :normal! t%vT%<CR>
vnoremap <silent> i% :normal! t%vT%<CR>
onoremap <silent> i^ :normal! t^vT^<CR>
vnoremap <silent> i^ :normal! t^vT^<CR>
