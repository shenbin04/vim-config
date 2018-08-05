if exists('b:current_syntax')
  finish
endif

runtime! syntax/jsx.vim

syn keyword snapKeywords exports
hi def link snapKeywords Keyword

syn match snapHeader "\v^\/\/ .+"
hi def link snapHeader Comment

syn match snapName "\v`([^`]+)`"
hi def link snapName String

let b:current_syntax = 'snap'
