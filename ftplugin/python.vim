setlocal textwidth=120
setlocal colorcolumn=+1

nnoremap <buffer> <silent> <Leader>ct :call python#NewTestFile()<CR>

nnoremap <buffer> <silent> <Leader>rd :call python#DebugTestFile()<CR>
nnoremap <buffer> <silent> <Leader>rr :call python#RunTestFile()<CR>

nnoremap <buffer> <silent> = :set operatorfunc=util#yapfOperator<CR>g@
nnoremap <buffer> <silent> == V:YAPF<CR>
vnoremap <buffer> <silent> = :call yapf#YAPF()<CR>
nnoremap <buffer> <silent> <Leader>fy :YAPF<CR>

nnoremap <buffer> <silent> <Leader>fe :call python#ShowError()<CR>
nnoremap <buffer> <silent> ]e :call python#ShowErrorNext()<CR>
nnoremap <buffer> <silent> [e :call python#ShowErrorPrev()<CR>

nnoremap <buffer> <silent> <Leader>fi :Isort<CR>
