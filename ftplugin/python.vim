setlocal textwidth=120
setlocal colorcolumn=+1

nnoremap <buffer> <silent> gj :call python#OpenPythonFile()<CR>
nnoremap <buffer> <silent> gt :call python#OpenTestFile()<CR>
nnoremap <buffer> <silent> gb :call python#OpenBuildFile()<CR>

nnoremap <buffer> <silent> <Leader>rpb :call python#BuildDeps()<CR>
nnoremap <buffer> <silent> <Leader>rpa :call python#BuildDepsAll()<CR>
nnoremap <buffer> <silent> <Leader>rpt :call python#TargetGen()<CR>
nnoremap <buffer> <silent> <Leader>rpp :call python#MakePants()<CR>

nnoremap <buffer> <silent> <Leader>rd :call util#Topen()<CR>:TestNearest -s<CR>
nnoremap <buffer> <silent> <Leader>rr :call python#RunTestFile()<CR>

nnoremap <buffer> <silent> <Leader>fb :Black<CR>

nnoremap <buffer> <silent> = :set operatorfunc=util#yapfOperator<CR>g@
nnoremap <buffer> <silent> == V:YAPF<CR>
vnoremap <buffer> <silent> = :call yapf#YAPF()<CR>
nnoremap <buffer> <silent> <Leader>fy :YAPF<CR>

nnoremap <buffer> <silent> <Leader>fe :call python#ShowError()<CR>
nnoremap <buffer> <silent> ]e :call python#ShowErrorNext()<CR>
nnoremap <buffer> <silent> [e :call python#ShowErrorPrev()<CR>
