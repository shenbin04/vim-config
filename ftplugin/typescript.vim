setlocal textwidth=120
setlocal colorcolumn=+1

nnoremap <buffer> <silent> <Leader>ff :call js#GoToDefinition()<CR>
nnoremap <buffer> <silent> <Leader>fp :LspHover<CR>
