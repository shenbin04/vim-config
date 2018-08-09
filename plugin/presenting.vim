au FileType markdown let g:presenting_slide_separator = '\v(^|\n)\ze#+'
au FileType notes    let g:presenting_slide_separator = '\v(^|\n)\ze# \S+'

if !exists('g:presenting_active')
  let g:presenting_active = 0
endif

if !exists('g:presenting_statusline')
  let g:presenting_statusline =
    \ '%{b:presenting_page_current}/%{b:presenting_page_total}'
endif

if !exists('g:presenting_top_margin')
  let g:presenting_top_margin = 0
endif

command! StartPresenting call presenting#Start(getline('.'))
command! PresentingStart call presenting#Start(getline('.'))
