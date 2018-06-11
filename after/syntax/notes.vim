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

syntax region notesHighlight matchgroup=notesHighlightMarker start=/$\ze\S/ end=/\S\zs\$/ contains=@Spell concealends containedin=notesUnixPath, notesHighlightSecondary, notesHighlightAdditional
highlight link notesHighlightMarker notesHiddenMarker

syntax region notesHighlightSecondary matchgroup=notesHighlightSecondaryMarker start=/%\ze\S/ end=/\S\zs%/ contains=@Spell concealends containedin=notesUnixPath, notesHighlight, notesHighlightAdditional
highlight link notesHighlightSecondaryMarker notesHiddenMarker

syntax region notesHighlightAdditional matchgroup=notesHighlightAdditionalMarker start=/\^\ze\S/ end=/\S\zs\^/ contains=@Spell concealends containedin=notesUnixPath, notesHighlight, notesHighlightSecondary
highlight link notesHighlightAdditionalMarker notesHiddenMarker

hi link notesTitle Type
hi link notesSnippetASCII Directory
hi link notesUnixPath clear

hi notesHighlight ctermfg=81
hi notesHighlightSecondary ctermfg=118
hi notesHighlightAdditional ctermfg=208
