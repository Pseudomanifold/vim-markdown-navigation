" `vim` filetype plugin for simplified Markdown navigation

if exists("b:did_ftplugin")
  finish
endif

" Maps a Markdown header level to a regular expression. Captures both
" variants of the headers.
"
" Taken from: https://github.com/plasticboy/vim-markdown
let s:level_to_regex = {
    \ 1: '\v^(#[^#]@=|.+\n\=+$)',
    \ 2: '\v^(##[^#]@=|.+\n-+$)',
    \ 3: '\v^###[^#]@=',
    \ 4: '\v^####[^#]@=',
    \ 5: '\v^#####[^#]@=',
    \ 6: '\v^######[^#]@='
\ }

" Regular expression for matching all Markdown headers, regardless of
" their level. Captures both variants of headers.
"
" Taken from: https://github.com/plasticboy/vim-markdown
let s:all_headers_regex = '\v^(#|.+\n(\=+|-+)$)'

" Returns the level of the current content. This is the *last* header
" specified before or at the current line. Returns either a level, or
" zero, which indicates that the line is not part of a section with a
" valid header.
"
" Based on a similar function from: https://github.com/plasticboy/vim-markdown
function s:GetCurrentLevel()
  let l:l = line('.')
  while(l:l > 0)
    " Check which level matches the line and return it. 
    for l:key in keys(s:level_to_regex)
      if join(getline(l:l, l:l + 1), '\n') =~ get(s:level_to_regex, l:key)
        return l:key
      endif
    endfor
    let l:l -= 1
  endwhile

  " No valid header found
  return 0
endfunction

" Returns the line number of the *next* header of a given level. If no
" such header line number exists, returns zero. The *direction* of the
" search procedure can be changed.
function s:GetNextHeader(level, ...)
  let l:direction = get(a:, 2, '')
  echo l:direction
  let l:position = searchpos(get(s:level_to_regex, a:level), 'nW') 

  " Only interested in the line number, not in the column
  return l:position[0]
endfunction

" Moves the cursor to the *last* sibling header, i.e. the last header of
" the same level as under the cursor.
function MoveToLastSiblingHeader()
  let l:level = s:GetCurrentLevel()
  let l:next_sibling = s:GetNextHeader(l:level - 1)

  while search(get(s:level_to_regex, l:level), 'W', l:next_sibling) != 0
    " Nothing to do here in the body of the loop.
  endwhile
endfunction
