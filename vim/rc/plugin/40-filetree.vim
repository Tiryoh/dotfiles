let file_name = expand('%')

function! OpenFern()
  execute "Fern . -reveal=" . expand("%") . " -drawer -width=40 -toggle"
endfunction

if has('vim_starting') &&  file_name == ''
  autocmd VimEnter * nested call OpenFern()
endif

nnoremap <C-n> :call OpenFern()<CR>
