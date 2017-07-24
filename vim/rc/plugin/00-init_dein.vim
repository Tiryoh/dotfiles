"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

let g:plugin_dir = expand('~/.vim/dein')
let g:dein_dir = g:plugin_dir . '/repos/github.com/Shougo/dein.vim'
execute 'set runtimepath+=' . g:dein_dir

if !isdirectory(g:dein_dir)
  call mkdir(g:dein_dir, 'p')
  silent execute printf('!git clone %s %s', 'httpg://github.com/Shougo/dein.vim', g:dein_dir)
endif

