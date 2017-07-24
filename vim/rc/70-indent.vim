" indent
filetype plugin indent on
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set textwidth=0
set noexpandtab
function! s:toggle_indent()
  if &tabstop == 2
    setlocal shiftwidth=4
    setlocal tabstop=4
    setlocal softtabstop=4
  else
    setlocal shiftwidth=2
    setlocal tabstop=2
    setlocal softtabstop=2
  endif
endfunction
nnoremap <silent> <Space>ot :<C-u>call <SID>toggle_indent()<CR>

