" swapfile
set swapfile
if has('win32') || has('win64')
  set directory=$VIM/swap
else
  set directory=$HOME/.vim/swap
endif
set updatecount=500

