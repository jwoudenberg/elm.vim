let s:path = expand('<sfile>:p:h')

function! elmtools#GoToDefinition() abort
  echo s:path
  " TODO: make this an asynchronous function call.
  let l:result = system(s:path . '/../bin/elm-find-definitions ' . expand('%'))
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

function! elmtools#GoToModule(name) abort
  if empty(a:name) | return | endif
  let l:file = expand('%')
  let l:module_file = system(s:path . '/../bin/elm-resolve-module ' . l:file . ' ' . a:name)
  if filereadable(l:module_file)
    exec 'edit ' . fnameescape(l:module_file)
  else
    return s:error("Can't find module \"" . a:name . "\"")
  endif
endfunction

function! s:definitionsAsDict(definitions)
  let l:dict = {}
  for l:definition in a:definitions
    let l:dict[l:definition.name] = l:definition
  endfor
  return l:dict
endfunction

" Using the built-in :echoerr prints a stacktrace, which isn't that nice.
" From: https://github.com/moll/vim-node/blob/master/autoload/node.vim
function! s:error(msg)
	echohl ErrorMsg
	echomsg a:msg
	echohl NONE
	let v:errmsg = a:msg
endfunction
