setlocal tabstop=2
setlocal shiftwidth=2
setlocal comments=:•,:◦,:▸,:▹,:▪,:▫,:>
setlocal expandtab
setlocal textwidth=88
setlocal iskeyword+=:,;,,,.,',`,^,"

let g:presenting_top_margin = 5

nnoremap <buffer> <Leader>nb :call search('\v^\s*\zs• .+')<CR>
nnoremap <buffer> <Leader>pb :call search('\v^\s*\zs• .+', 'b')<CR>
nnoremap <buffer> <Leader>nt :call search('\v^\s*\zs# .+')<CR>
nnoremap <buffer> <Leader>pt :call search('\v^\s*\zs# .+', 'b')<CR>
nnoremap <buffer> <CR> :StartPresenting<CR>
nnoremap <buffer> gh :h <C-r><C-w><CR>

onoremap <buffer> as :call util#SelectBetweenPattern('\v^\s*# .+')<CR>
vnoremap <buffer> as :call util#SelectBetweenPattern('\v^\s*# .+')<CR>
