if !exists('g:color_name')
  colorscheme gruvbox

  hi! SpellBad ctermfg=235 ctermbg=167
  hi! SpellCap ctermfg=208 ctermbg=235 cterm=reverse,undercurl
  hi! link PreProc Identifier
  hi! link Function GruvboxOrange
  hi! link jsObjectKey GruvboxBlue
  hi! link jsObjectProp GruvboxBlue
  hi! link jsClassProperty GruvboxRed
endif

hi! Comment cterm=italic
