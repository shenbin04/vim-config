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

nnoremap <buffer> gj :call js#OpenJSFile()<CR>
nnoremap <buffer> gt :call js#OpenTestFile()<CR>
nnoremap <buffer> gc :call js#OpenScssFile()<CR>
nnoremap <buffer> gs :call js#OpenSnapshotFile()<CR>

nnoremap <buffer> <Leader>ru :TestFile -u<CR>
nnoremap <buffer> <Leader>rr :call js#RunTestFile()<CR>
nnoremap <buffer> <Leader>rw :call js#RunTestWatch()<CR>

nnoremap <buffer> <Leader>rni :call js#RequireToImport()<CR>
nnoremap <buffer> <Leader>rno :call js#OrganizeImports()<CR>

onoremap <buffer> if :call js#JSFunctionAction('')<CR>
onoremap <buffer> af :call js#JSFunctionAction('k')<CR>
onoremap <buffer> ik :call js#JSPropertyAction()<CR>
onoremap <buffer> ic :call js#JSFunctionCallAction('')<CR>
onoremap <buffer> ac :call js#JSFunctionCallAction('k')<CR>

nnoremap <buffer> <Leader>fb :call js#FormatImportBreak()<CR>
nnoremap <buffer> <Leader>fj :call js#FormatImportJoin()<CR>
nnoremap <buffer> <leader>fm V:EsformatterVisual<CR>k=a<.....
vnoremap <buffer> <leader>fm :EsformatterVisual<CR>k=a<.....
