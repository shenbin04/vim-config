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

nnoremap <buffer> <Leader>rl :call js#RunJestFocused()<CR>|
nnoremap <buffer> <Leader>rr :call js#RunJestOnBuffer()<CR>|
nnoremap <buffer> <Leader>ru :call js#RunJestOnBufferUpdate()<CR>|
nnoremap <buffer> <Leader>rw :call js#RunJestOnBufferWatch()<CR>
