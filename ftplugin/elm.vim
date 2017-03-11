if exists('b:loaded_elm_vim_plugin')
  finish
endif

let b:loaded_elm_vim_plugin = 1

" TODO: document this command.
command -buffer GoToDefinition call s:goToDefinition()
nnoremap <silent> <Plug>(elm-goto-definition) :GoToDefinition<CR>

" TODO: move this function to autoload.
let s:path = expand('<sfile>:p:h')
function! s:goToDefinition()
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
