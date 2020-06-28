let colorscheme = get(g:, 'colors_name', '')
if empty(colorscheme)
  colorscheme gruvbox

  hi! clear Normal
  hi! SpellBad ctermfg=235 ctermbg=167
  hi! SpellCap ctermfg=208 ctermbg=235 cterm=reverse,undercurl
  hi! link PreProc Identifier
  hi! link Function GruvboxOrange
  hi! link Ignore GruvboxGray
  hi! link jsObjectKey GruvboxBlue
  hi! link jsObjectProp GruvboxBlue
  hi! link jsClassProperty GruvboxRed
  hi! link NERDTreeDir GruvboxBlue
  hi! link NERDTreeDirSlash GruvboxBlue
  hi! link NERDTreeOpenable GruvboxGray
  hi! link NERDTreeClosable GruvboxOrange
  hi! link pythonDottedName GruvboxOrange
  hi! link semshiAttribute GruvboxBlue
  hi! link semshiBuiltin GruvboxRed
  hi! link semshiParameter GruvboxYellow
  hi! link semshiSelf GruvboxOrange
  hi! link semshiUnresolved semshiErrorSign
elseif colorscheme == 'molokai'
  hi! GitGutterAdd ctermfg=28 ctermbg=234
  hi! GitGutterAddLine ctermfg=28 ctermbg=234
  hi! GitGutterChange ctermfg=3 ctermbg=234
  hi! GitGutterDelete ctermfg=1 ctermbg=234
  hi! GitGutterChangeDelete ctermfg=3 ctermbg=234
  hi! NERDTreeDir ctermfg=81
  hi! NERDTreeDirSlash ctermfg=81
  hi! NERDTreeCWD ctermfg=118
  hi! NERDTreeOpenable ctermfg=59
  hi! NERDTreeClosable ctermfg=7
  hi! notesName ctermfg=81 cterm=underline
endif

hi! Comment cterm=italic

hi! link TermCursorNC Cursor

hi! ALEErrorSign ctermfg=015 ctermbg=001 cterm=none
hi! ALEWarningSign ctermfg=015 ctermbg=166 cterm=none
hi! link ALEError clear
hi! link ALEWarning clear
