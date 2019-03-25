setlocal textwidth=120
setlocal colorcolumn=+1

nnoremap <buffer> gj :call python#OpenPythonFile()<CR>
nnoremap <buffer> gt :call python#OpenTestFile()<CR>
nnoremap <buffer> gb :call python#OpenBuildFile()<CR>

nnoremap <buffer> <Leader>rpb :call python#BuildDeps()<CR>
nnoremap <buffer> <Leader>rpa :call python#BuildDepsAll()<CR>
nnoremap <buffer> <Leader>rpt :call python#TargetGen()<CR>
nnoremap <buffer> <Leader>rpg :call python#GenAll()<CR>

nnoremap <buffer> <Leader>rpim :call python#InstallExtDeps('python/manhattan:')<CR>
nnoremap <buffer> <Leader>rpir :call python#InstallExtDeps('internal-site/internal_site:')<CR>
nnoremap <buffer> <Leader>rpib :call python#InstallExtDeps('python/batmobile:')<CR>
nnoremap <buffer> <Leader>rpif :call python#InstallExtDeps('python/dev_tools/foreman:')<CR>

nnoremap <buffer> <Leader>rd :Topen<CR>:TestNearest -s<CR>
nnoremap <buffer> <Leader>rr :call python#RunTestFile()<CR>

nnoremap <buffer> <Leader>fb :Black<CR>

nnoremap <buffer> <silent> = :set operatorfunc=util#yapfOperator<CR>g@
nnoremap <buffer> <silent> == V:YAPF<CR>
vnoremap <buffer> <silent> = :call yapf#YAPF()<CR>
nnoremap <buffer> <silent> <Leader>fy :YAPF<CR>
