syntax match notesAtxMarker /\v^\s*\zs#+ / conceal
hi def link notesAtxMarker Comment

syntax match foldingMark /\v.*\zs \<$/ conceal
hi default link foldingMark Comment

syntax match notesAtxHeading1 /\v^\s*# +.*/ contains=notesAtxMarker,foldingMark,@notesInline
hi def link notesAtxHeading1 Keyword

syntax match notesAtxHeading2 /\v^\s*## +.*/ contains=notesAtxMarker,foldingMark,@notesInline
hi default link notesAtxHeading2 Title

syntax match notesAtxHeading3 /\v^\s*### +.*/ contains=notesAtxMarker,foldingMark,@notesInline
hi default link notesAtxHeading3 String

hi link notesTitle Type
hi link notesSnippetTEXT Directory

hi notesBold ctermfg=81
