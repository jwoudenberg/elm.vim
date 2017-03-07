if exists('b:loaded_elm_vim_plugin')
  finish
endif

let b:loaded_elm_vim_plugin = 1

command -buffer GoToDefinition call s:goToDefinition()

let s:path = expand('<sfile>:p:h')
function! s:goToDefinition()
  echo s:path
  echom system(s:path . '/../lib/parse-elm-experiment-exe ' . expand('%'))
endfunction
