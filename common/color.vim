if !exists('g:color_name')
  colorscheme gruvbox

  hi! link PreProc Identifier
  hi! link Function GruvboxOrange
  hi! link jsObjectKey GruvboxBlue
  hi! link jsObjectProp GruvboxBlue
  hi! link jsClassProperty GruvboxRed
endif

hi! Comment cterm=italic
