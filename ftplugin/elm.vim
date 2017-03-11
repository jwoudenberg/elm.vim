if exists('b:loaded_elm_vim_plugin')
  finish
endif

let b:loaded_elm_vim_plugin = 1

" TODO: document this command.
command -buffer GoToDefinition call elmtools#GoToDefinition()
nnoremap <silent> <Plug>(elm-goto-definition) :GoToDefinition<CR>
