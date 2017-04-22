let s:path = expand('<sfile>:p:h')

function! elmtools#GoToDefinition() abort
  echo s:path
  " TODO: make this an asynchronous function call.
  let l:result = system(s:path . '/../bin/elm-find-definition ' . expand('%') . ' ' . expand('<cWORD>'))
  if v:shell_error
    echo 'Parsing elm file failed: ' . l:result
    return
  endif
  let l:definition = json_decode(l:result)
  call cursor(l:definition.line, l:definition.column)
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

" Using the built-in :echoerr prints a stacktrace, which isn't that nice.
" From: https://github.com/moll/vim-node/blob/master/autoload/node.vim
function! s:error(msg)
	echohl ErrorMsg
	echomsg a:msg
	echohl NONE
	let v:errmsg = a:msg
endfunction
