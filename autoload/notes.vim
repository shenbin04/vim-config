function! notes#FormatTable() range
  Tabularize /|
  execute "'<,'>call notes#FormatRange()"
endfunction

function! notes#FormatRange() range
  let pattern = '\v\| \zs[^|]+\ze \|'
  let top = a:firstline
  let bot = a:lastline

  let lines = map(range(top, bot), 'getline(v:val)')
  let [maxes, data] = s:ProcessLines(lines)
  let results = repeat([''], len(lines))
  let n = 0
  for line in lines
    let i = 0
    let result = line
    for sec in data[n]
      let max = maxes[i]
      let diff = sec.wc - max.wc - max.wd
      let substr = sec.str
      if match(sec.str, '\v^-+ *$') >= 0
        let substr = repeat('-', max.w)
      elseif diff < 0
        let substr = sec.str[0:diff - 1]
      elseif diff > 0
        let substr = sec.str . repeat(' ', diff)
      endif
      let result = substitute(result, '\V\( \[^|]\*|\)\{' . (i + 1) . '} \zs' . escape(sec.str, '\'), escape(substr, '\&'), '')
      let i += 1
    endfor
    let results[n] = result
    let n += 1
  endfor
  execute top . ',' . bot . 'delete _'
  call append(top - 1, results)
  call cursor(top, 0)
endfunction

function! s:ProcessLines(lines)
  let maxes = []
  let data = map(repeat([[]], len(a:lines)), 'copy(v:val)')
  let n = 0
  for line in a:lines
    let i = 1
    let [str, w, wc] = s:ProcessLine(line, i)
    while w
      let data[n] += [{'str': str, 'wc': wc}]
      if i > len(maxes)
        let maxes += [{'w': w, 'wc': wc, 'wd': len(str) - w - wc}]
      else
        let max_current = maxes[i - 1]
        if w > max_current.w && str !~ '\v^-+ *$'
          let max_current.w = w
          let max_current.wc = wc
          let max_current.wd = len(str) - w - wc
        endif
      endif
      let i += 1
      let [str, w, wc] = s:ProcessLine(line, i)
    endwhile
    let n += 1
  endfor
  return [maxes, data]
endfunction

function! s:ProcessLine(line, i)
  let pattern = '\v\| \zs[^|]+\ze \|'
  let str = matchstr(a:line, pattern, 0, a:i)
  let wc = s:CalculateConcealing(str)
  return [str, len(xolox#misc#str#trim(str)) - wc, wc]
endfunction

function! s:CalculateConcealing(string)
  let chars = split(a:string, '\zs')
  if !exists('g:notes_concealing_delimeters')
    return 0
  endif

  return eval(join(map(copy(g:notes_concealing_delimeters), {k, v -> count(chars, v) / 2 * 2}), '+'))
endfunction

function! notes#GenerateTOC()
  echo 'Genrating TOC'
  normal! gg
  let top = search('\v^# Contents', 'n')
  if top > 0
    let lines = uniq(filter(map(getline(top + 1, '$'), 'matchstr(v:val, "\\v^# \\zs\\w+")'), 'v:val != ""'))
    let lines = map(lines, 'repeat(" ", &shiftwidth) . "• " . v:val')
    execute 'normal! ' . top . 'gg'
    call cursor(top + 1, 0)
    let next_section = search('\v^# .+', 'n')
    execute (top + 1) . ',' . (next_section - 1) . 'delete _'
    call insert(lines, '')
    call add(lines, '')
    call append(top, lines)
    call cursor(top, 0)
  endif
endfunction
