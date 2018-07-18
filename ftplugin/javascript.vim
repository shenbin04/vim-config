setlocal textwidth=120
setlocal colorcolumn=+1
setlocal formatprg=prettier\ --trailing-comma\ all\ --no-bracket-spacing\ --stdin

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

nnoremap <buffer> <Leader>rr :call js#RunTestFile()<CR>
nnoremap <buffer> <Leader>rw :call js#RunTestWatch()<CR>
nnoremap <buffer> <Leader>rl :call js#RunTestLine()<CR>
nnoremap <buffer> <Leader>rd :call js#RunTestDebug()<CR>
nnoremap <buffer> <Leader>ru :call js#RunTestUpdate()<CR>

nnoremap <buffer> <Leader>rf :call js#RunFlow()<CR>
nnoremap <buffer> <Leader>rt :call js#RunTest('')<CR>
nnoremap <buffer> <Leader>rc :call js#RunTest('--watch')<CR>

nnoremap <buffer> <Leader>rni :call js#RequireToImport()<CR>
nnoremap <buffer> <Leader>rno :call js#OrganizeImports()<CR>

onoremap <buffer> if :call js#FindFunction('')<CR>
vnoremap <buffer> if :call js#FindFunction('')<CR>
nnoremap <buffer> <Leader>nf :call js#FindFunctionNext()<CR>
nnoremap <buffer> <Leader>pf :call js#FindFunctionPrevious()<CR>
onoremap <buffer> af :call js#FindFunction('j')<CR>
vnoremap <buffer> af :call js#FindFunction('j')<CR>
onoremap <buffer> ik :call js#FindProperty()<CR>
vnoremap <buffer> ik :call js#FindProperty()<CR>
onoremap <buffer> iit :call js#FindTestCase('')<CR>
vnoremap <buffer> iit :call js#FindTestCase('')<CR>
onoremap <buffer> ait :call js#FindTestCase('j')<CR>
vnoremap <buffer> ait :call js#FindTestCase('j')<CR>

nnoremap <buffer> <Leader>fb :call js#FormatImportBreak()<CR>
nnoremap <buffer> <Leader>fj :call js#FormatImportJoin()<CR>
nnoremap <buffer> <leader>fm V:EsformatterVisual<CR>k=a<.....
vnoremap <buffer> <leader>fm :EsformatterVisual<CR>k=a<.....

nnoremap <buffer> tap 0f(i = <ESC>f)a =><ESC>
nnoremap <buffer> taf 0/function<CR>dw/)<CR>a =><ESC>:noh<CR>
nnoremap <buffer> tae 0/function<CR>dwiconst <ESC>wwi = <ESC>/)<CR>a =><ESC>/{<CR>%a;<ESC>
