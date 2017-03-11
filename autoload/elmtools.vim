let s:path = expand('<sfile>:p:h')

function! elmtools#GoToDefinition() abort
  echo s:path
  " TODO: make this an asynchronous function call.
  let l:result = system(s:path . '/../lib/elm-editor-tools-exe ' . expand('%'))
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
  echo 'Could not find definition of: ' . l:term
endfunction
