setlocal tabstop=2
setlocal shiftwidth=2
setlocal comments=:•,:◦,:▸,:▹,:▪,:▫,:>
setlocal expandtab
setlocal textwidth=88
setlocal iskeyword+=:,;,,,.,',` iskeyword-=$,^

let g:presenting_top_margin = 5
let g:notes_concealing_delimeters = ['$', '%', '^']

nnoremap <buffer> <Leader>nb :call search('\v^\s*\zs• .+')<CR>
nnoremap <buffer> <Leader>pb :call search('\v^\s*\zs• .+', 'b')<CR>
nnoremap <buffer> <Leader>ns :call search('\v^\s*\zs# .+')<CR>
nnoremap <buffer> <Leader>ps :call search('\v^\s*\zs# .+', 'b')<CR>
nnoremap <buffer> <CR> :StartPresenting<CR>

onoremap <buffer> as :call util#SelectBetweenPattern('\v^\s*# .+')<CR>
vnoremap <buffer> as :call util#SelectBetweenPattern('\v^\s*# .+')<CR>

vnoremap <buffer> <silent> ft :call notes#FormatTable()<CR>
