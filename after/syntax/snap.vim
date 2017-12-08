if exists('b:current_syntax')
  let s:current_syntax=b:current_syntax
  unlet b:current_syntax
endif
syn include @XMLSyntax syntax/xml.vim
if exists('s:current_syntax')
  let b:current_syntax=s:current_syntax
endif

syn keyword snapKeywords exports
syn match snapName "\v`([^`]+)`"
syn region xmlString contained start=+{+ end=++ contains=jsBlock,javascriptBlock
syn region jsxChild contained start=+{+ end=++ contains=jsBlock,javascriptBlock
  \ extend
syn region jsxRegion
  \ contains=@Spell,@XMLSyntax,jsxRegion,jsxChild,jsBlock,javascriptBlock
  \ start=+\%(<\|\w\)\@<!<\z([a-zA-Z][a-zA-Z0-9:\-.]*\)+
  \ skip=+<!--\_.\{-}-->+
  \ end=+</\z1\_\s\{-}>+
  \ end=+/>+
  \ keepend
  \ extend
syn cluster jsExpression add=jsxRegion
syn cluster javascriptNoReserved add=jsxRegion
