syntax match notesAtxHeading /^\s*#\+.*/ contains=notesAtxMarker,@notesInline
highlight def link notesAtxHeading Title
syntax match notesAtxMarker /^\s*#\+/ contained
highlight def link notesAtxMarker Comment

syntax match notesAtxHeading2 /^\s*##\+.*/ contains=notesAtxMarker,@notesInline
hi default link notesAtxHeading2 notesAtxHeading
