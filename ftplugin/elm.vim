if exists('b:loaded_elm_vim_plugin')
  finish
endif

let b:loaded_elm_vim_plugin = 1

" TODO: expose this command as a <PLUG> mapping too.
" TODO: document this command.
command -buffer GoToDefinition call s:goToDefinition()

" TODO: move this function to autoload.
let s:path = expand('<sfile>:p:h')
function! s:goToDefinition()
  echo s:path
  " TODO: make this an asynchronous function call.
  let l:result = system(s:path . '/../lib/parse-elm-experiment-exe ' . expand('%'))
  if v:shell_error
    echo 'Parsing elm file failed: ' . l:result
    return
  endif
  let l:term = expand('<cWORD>')
  let l:definitions = json_decode(l:result)
  " TODO: Remove this loop by changing the definitions list to a dictionary.
  for l:definition in l:definitions
    if l:definition.name == l:term
      call cursor(l:definition.line, l:definition.column)
      return
    endif
  endfor
  " TODO: Tell the user when the term they jump to could not be found.
endfunction
