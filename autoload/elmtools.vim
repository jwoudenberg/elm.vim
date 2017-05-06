let s:path = expand('<sfile>:p:h')

function! elmtools#GoToDefinition() abort
  echo s:path
  " TODO: make this an asynchronous function call.
  let l:cWORD = expand('<cWORD>')
  " Trim non-variable characters from both sides of the WORD under the cursor.
  let l:name = substitute(l:cWORD, '\v^\W*((\w|\.)+)\W*$', '\1', '')
  let l:result = system(s:path . '/../bin/elm-find-definition ' . expand('%') . ' ' . l:name)
  if v:shell_error
    echo 'Parsing elm file failed: ' . l:result
    return
  endif
  let l:definition = json_decode(l:result)
  exec 'edit ' . fnameescape(l:definition.fileName)
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
