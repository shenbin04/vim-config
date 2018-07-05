syntax match notesAtxMarker /\v^\s*\zs#+ / conceal
hi def link notesAtxMarker Comment

syntax match foldingMark /\v.*\zs \<$/ conceal
hi default link foldingMark Comment

syntax match notesAtxHeading1 /\v^\s*# +.*/ contains=notesAtxMarker,foldingMark,@notesInline
hi default link notesAtxHeading1 Keyword

syntax match notesAtxHeading2 /\v^\s*## +.*/ contains=notesAtxMarker,foldingMark,@notesInline
hi default link notesAtxHeading2 Title

syntax match notesAtxHeading3 /\v^\s*### +.*/ contains=notesAtxMarker,foldingMark,@notesInline
hi default link notesAtxHeading3 String

syntax region notesHighlight matchgroup=notesHighlightMarker start=/\v\$\ze\S.*$/ end=/\v\$?\zs\$/ concealends
      \ contains=@Spell, notesHighlightSecondary, notesHighlightAdditional
      \ containedin=notesUnixPath
highlight link notesHighlightMarker notesHiddenMarker

syntax region notesHighlightSecondary matchgroup=notesHighlightSecondaryMarker start=/\v\%\ze[^$ ][^$]*\%[^$]*\$?.*$/ end=/\zs%/ concealends
      \ contains=@Spell, notesHighlight, notesHighlightAdditional
      \ containedin=notesUnixPath
highlight link notesHighlightSecondaryMarker notesHiddenMarker

syntax region notesHighlightAdditional matchgroup=notesHighlightAdditionalMarker start=/\v\^\ze[^$ ][^$]*\^[^$]*\$?.*$/ end=/\zs\^/ concealends
      \ contains=@Spell, notesHighlight, notesHighlightSecondary
      \ containedin=notesUnixPath
highlight link notesHighlightAdditionalMarker notesHiddenMarker

syntax region notesURL matchgroup=notesDelimiter start="(" end=")" contained oneline
syntax region notesLink matchgroup=notesDelimiter start="\\\@<!!\?\[\ze[^]\n]*\n\?[^]\n]*\][[(]" end="\]" contains=@Spell nextgroup=notesURL skipwhite concealends

hi link notesLink Type

hi link notesTitle Type
hi link notesSnippetASCII Directory
hi link notesUnixPath clear

hi notesHighlight ctermfg=81
hi notesHighlightSecondary ctermfg=118
hi notesHighlightAdditional ctermfg=208
