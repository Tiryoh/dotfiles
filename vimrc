" vimrc
" Copyright (c) 2016 Tiryoh

let g:vim_dir = expand("~/.vim")
execute 'set runtimepath^=' . g:vim_dir
runtime! rc/*.vim
