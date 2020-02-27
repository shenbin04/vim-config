setlocal textwidth=120
setlocal colorcolumn=+1

hi link jsClassProperty jsClassFuncName
hi link jsObjectKey Identifier
hi link jsImport jsClassKeyword
hi link jsFrom jsClassKeyword
hi link jsExport jsClassKeyword
hi link jsExtendsKeyword jsClassKeyword
hi link jsObjectKeyComputed jsGlobalObjects
hi link jsFlowObject Identifier
hi link jsFlowGroup Identifier
hi link jsFlowTypeStatement jsGlobalObjects
hi link jsFlowTypeValue jsGlobalObjects
hi link jsFlowTypeof jsClassKeyword
hi link jsFlowImportType jsGlobalObjects
hi jsThis ctermfg=81
hi jsFuncCall ctermfg=81
hi jsFuncName ctermfg=118
hi jsClassDefinition ctermfg=81
hi jsTemplateBraces ctermfg=81

runtime common/js_switch.vim
runtime common/run_flow.vim

nnoremap <buffer> <silent> <Leader>ct :call js#NewTestFile()<CR>

nnoremap <buffer> <silent> <Leader>fc :call js#ShowFlowCoverage()<CR>
nnoremap <buffer> <silent> <Leader>fp :FlowTypeAtPos<CR>

nnoremap <buffer> <silent> <Leader>rr :call js#RunTestFile()<CR>
nnoremap <buffer> <silent> <Leader>rw :call js#RunTestWatch()<CR>
nnoremap <buffer> <silent> <Leader>ro :call js#RunTestOnly()<CR>
nnoremap <buffer> <silent> <Leader>rl :call js#RunTestLine()<CR>
nnoremap <buffer> <silent> <Leader>rd :call js#RunTestDebug()<CR>
nnoremap <buffer> <silent> <Leader>ru :call js#RunTestUpdate()<CR>

nnoremap <buffer> <silent> <Leader>rku :call util#SendKeys('u')<CR>

nnoremap <buffer> <silent> <Leader>rtt :call js#RunTestsInProject('')<CR>
nnoremap <buffer> <silent> <Leader>rto :call js#RunTestsInProject('-o')<CR>
nnoremap <buffer> <silent> <Leader>rtu :call js#RunTestsInProject('-u')<CR>
nnoremap <buffer> <silent> <Leader>rtw :call js#RunTestsInProject('--watch')<CR>

nnoremap <buffer> <silent> <Leader>rtaa :call js#RunTestsAll('')<CR>
nnoremap <buffer> <silent> <Leader>rtao :call js#RunTestsAll('-o')<CR>
nnoremap <buffer> <silent> <Leader>rtau :call js#RunTestsAll('-u')<CR>
nnoremap <buffer> <silent> <Leader>rtaw :call js#RunTestsAll('--watch')<CR>

nnoremap <buffer> <silent> <Leader>rni :call js#RequireToImport()<CR>
nnoremap <buffer> <silent> <Leader>rno :call js#OrganizeImports()<CR>
nnoremap <buffer> <silent> <Leader>rntc :call js#TypeConnect()<CR>

onoremap <buffer> if :call js#FindFunction('')<CR>
vnoremap <buffer> if :call js#FindFunction('')<CR>
onoremap <buffer> af :call js#FindFunction('j')<CR>
vnoremap <buffer> af :call js#FindFunction('j')<CR>
noremap <script> <buffer> <silent> [[ <nop>
noremap <script> <buffer> <silent> ]] <nop>
nnoremap <buffer> <silent> [[ :call js#FindFunctionPrevious()<CR>
nnoremap <buffer> <silent> ]] :call js#FindFunctionNext()<CR>

onoremap <buffer> ik :call js#FindProperty()<CR>
vnoremap <buffer> ik :call js#FindProperty()<CR>

onoremap <buffer> iit :call js#FindTestCase('')<CR>
vnoremap <buffer> iit :call js#FindTestCase('')<CR>
onoremap <buffer> ait :call js#FindTestCase('j')<CR>
vnoremap <buffer> ait :call js#FindTestCase('j')<CR>

nnoremap <buffer> <silent> <Leader>fob :call js#FormatObjectBreak()<CR>
nnoremap <buffer> <silent> <Leader>foj :call js#FormatObjectJoin()<CR>
nnoremap <buffer> <silent> <Leader>fos :call js#FormatObjectSort()<CR>
nnoremap <buffer> <silent> <Leader>fjb :call js#FormatJsxBreak()<CR>
nnoremap <buffer> <silent> <Leader>fjj :call js#FormatJsxJoin()<CR>
nnoremap <buffer> <silent> <Leader>fjs :call js#FormatJsxSort()<CR>
nnoremap <buffer> <silent> <Leader>ftb :call js#FormatTagBreak()<CR>
nnoremap <buffer> <silent> <Leader>ftj :call js#FormatTagJoin()<CR>

vnoremap <buffer> <silent> <Leader>fes :EsformatterVisual<CR>

nnoremap <buffer> <silent> <Leader>ftap :call js#ClassFunctionToClassProperty()<CR>
nnoremap <buffer> <silent> <Leader>ftaf :call js#ToArrowFunction()<CR>

nnoremap <buffer> <silent> <Leader>fe :call js#ShowError()<CR>

nnoremap <buffer> <F3> :FlowCoverageToggle<CR>

nnoremap <buffer> <silent> <Leader>ff :call js#GoToDefinition()<CR>
nnoremap <buffer> <silent> <Leader>fr :TernRename<CR>

let b:AutoPairs = AutoPairsDefine({'|' : '|'})

call js#SendFileToTern()
call js#SetPath()
