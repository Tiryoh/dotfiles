" run 'call dein#clear_state()' to force reload

" global settings
syntax on
set nocompatible title number cindent
set backspace=2
set clipboard+=unnamedplus,unnamed
set laststatus=2
set cmdheight=2
set titleold=zsh
set cursorline

filetype off
filetype plugin indent off

" colorscheme settings
"silent! colorscheme jellybeans
colorscheme default

" dein.vim
execute 'if filereadable(expand("' . g:vim_dir . '/dein/repos/github.com/Shougo/dein.vim/README.md"))'
  runtime! rc/plugin/*.vim
endif
