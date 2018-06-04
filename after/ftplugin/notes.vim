setlocal tabstop=2
setlocal shiftwidth=2
setlocal comments=:•,:◦,:▸,:▹,:▪,:▫,:>
setlocal expandtab

let g:presenting_top_margin = 5

nnoremap <buffer> <Leader>nb /\v• \zs.+<CR>:noh<CR>
nnoremap <buffer> <Leader>pb ?\v• \zs.+<CR>:noh<CR>
nnoremap <buffer> <Leader>nt /\v# \zs.+<CR>:noh<CR>
nnoremap <buffer> <Leader>pt ?\v# \zs.+<CR>:noh<CR>
nnoremap <buffer> <C-S-P> :StartPresenting<CR>
