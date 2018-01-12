nnoremap <buffer> gj :call python#OpenPythonFile()<CR>
nnoremap <buffer> gt :call python#OpenTestFile()<CR>
nnoremap <buffer> gb :call python#OpenBuildFile()<CR>

nnoremap <buffer> <Leader>rpb :call python#BuildDeps()<CR>
nnoremap <buffer> <Leader>rpt :call python#TargetGen()<CR>
nnoremap <buffer> <Leader>rpg :call python#GenAll()<CR>
