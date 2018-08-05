if exists('b:current_syntax')
  finish
endif

runtime! syntax/jsx.vim

syn keyword snapKeywords exports
syn match snapHeader "\v^\/\/.+"
syn match snapName "\v`([^`]+)`"

hi default link snapKeywords Keyword
hi default link snapHeader Comment
hi default link snapName String

let b:current_syntax = 'snap'
