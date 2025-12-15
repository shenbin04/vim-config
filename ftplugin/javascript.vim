setlocal textwidth=120
setlocal colorcolumn=+1

runtime common/run_flow.vim

nnoremap <buffer> <silent> <Leader>cntj :call js#NewTestFile('ntj')<CR>
nnoremap <buffer> <silent> <Leader>cnte :call js#NewTestFile('nte')<CR>
nnoremap <buffer> <silent> <Leader>cntt :call js#NewTestFile('ntt')<CR>
nnoremap <buffer> <silent> <Leader>cns :call js#NewScssFile()<CR>

nnoremap <buffer> <silent> <Leader>rr :call js#RunTestFile('')<CR>
nnoremap <buffer> <silent> <Leader>ru :call js#RunTestFile('-u')<CR>
nnoremap <buffer> <silent> <Leader>rw :call js#RunTestFile('--watch')<CR>

nnoremap <buffer> <silent> <Leader>rl :call js#RunTestLine()<CR>
nnoremap <buffer> <silent> <Leader>rd :call js#RunTestDebug()<CR>

nnoremap <buffer> <silent> <Leader>rtt :call js#RunTestsInProject('')<CR>
nnoremap <buffer> <silent> <Leader>rto :call js#RunTestsInProject('-o')<CR>
nnoremap <buffer> <silent> <Leader>rtu :call js#RunTestsInProject('-o -u')<CR>
nnoremap <buffer> <silent> <Leader>rtw :call js#RunTestsInProject('--watch')<CR>

nnoremap <buffer> <silent> <Leader>rtaa :call js#RunTestsAll('')<CR>
nnoremap <buffer> <silent> <Leader>rtao :call js#RunTestsAll('-o')<CR>
nnoremap <buffer> <silent> <Leader>rtau :call js#RunTestsAll('-u')<CR>
nnoremap <buffer> <silent> <Leader>rtaw :call js#RunTestsAll('--watch')<CR>

onoremap <buffer> if :call js#FindFunction('')<CR>
vnoremap <buffer> if :call js#FindFunction('')<CR>
onoremap <buffer> af :call js#FindFunction('j')<CR>
vnoremap <buffer> af :call js#FindFunction('j')<CR>
noremap <buffer> <silent> <script> [[ <nop>
noremap <buffer> <silent> <script> ]] <nop>
nnoremap <buffer> <silent> [[ :call js#FindFunctionPrevious()<CR>
nnoremap <buffer> <silent> ]] :call js#FindFunctionNext()<CR>

onoremap <buffer> ik :call js#FindProperty()<CR>
vnoremap <buffer> ik :call js#FindProperty()<CR>

onoremap <buffer> ij :call js#FindTestCase('')<CR>
vnoremap <buffer> ij :call js#FindTestCase('')<CR>
onoremap <buffer> aj :call js#FindTestCase('j')<CR>
vnoremap <buffer> aj :call js#FindTestCase('j')<CR>

nnoremap <buffer> <silent> <Leader>fos :call js#FormatObjectSort()<CR>
nnoremap <buffer> <silent> <Leader>fjs :call js#FormatJsxSort()<CR>

nnoremap <buffer> <silent> <Leader>mr :call js#MovetoReact()<CR>

nnoremap <buffer> <silent> <Leader>ftap :call js#ClassFunctionToClassProperty()<CR>
nnoremap <buffer> <silent> <Leader>ftaf :call js#ToArrowFunction()<CR>

nnoremap <buffer> <silent> <Leader>fe :call js#ShowError()<CR>

nnoremap <buffer> <F3> :FlowCoverageToggle<CR>:call js#ShowFlowCoverage()<CR>

let b:AutoPairs = AutoPairsDefine({'|' : '|'})

call js#SendFileToTern()
