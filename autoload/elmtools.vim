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
  " TODO: cache this operation.
  let l:definitions = s:definitionsAsDict(json_decode(l:result))
  if has_key(l:definitions, l:term)
    let l:definition = l:definitions[l:term]
    call cursor(l:definition.line, l:definition.column)
    return
  endif
  echo 'Could not find definition of: ' . l:term
endfunction

function s:definitionsAsDict(definitions)
  let l:dict = {}
  for l:definition in a:definitions
    let l:dict[l:definition.name] = l:definition
  endfor
  return l:dict
endfunction
