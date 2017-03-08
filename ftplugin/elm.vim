if exists('b:loaded_elm_vim_plugin')
  finish
endif

let b:loaded_elm_vim_plugin = 1

command -buffer GoToDefinition call s:goToDefinition()

let s:path = expand('<sfile>:p:h')
function! s:goToDefinition()
  echo s:path
  let l:result = system(s:path . '/../lib/parse-elm-experiment-exe ' . expand('%'))
  if v:shell_error
    echo 'Parsing elm file failed: ' . l:result
    return
  endif
  let l:term = expand('<cWORD>')
  let l:definitions = json_decode(l:result)
  for l:definition in l:definitions
    if l:definition.name == l:term
      call cursor(l:definition.line, l:definition.column)
      return
    endif
  endfor
endfunction
