syntax match notesAtxHeading1 /^\s*# \+.*/ contains=notesAtxMarker,@notesInline
hi def link notesAtxHeading1 Keyword

syntax match notesAtxMarker /^\s*#\+/ contained
hi def link notesAtxMarker Comment

syntax match notesAtxHeading2 /^\s*## \+.*\ze <$/ contains=notesAtxMarker,@notesInline
hi default link notesAtxHeading2 Title

syntax match FoldingMark "\v.*\zs \<$" conceal
hi default link FoldingMark Comment

hi link notesTitle Type
