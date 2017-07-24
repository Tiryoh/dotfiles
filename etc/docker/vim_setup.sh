#!/bin/bash -eu

mv ${HOME}/.vim/rc/plugin/90-check_install.vim ${HOME}/.vim/rc/plugin/90-check_install.vim.back
vim -c ":silent! call dein#install() | :q"
mv ${HOME}/.vim/rc/plugin/90-check_install.vim.back ${HOME}/.vim/rc/plugin/90-check_install.vim
