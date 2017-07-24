" backup
set nobackup
"set writebackup
"set backupskip = escape(expand('$HOME'), '\') . '/tmp/*'
augroup Backup
  autocmd!
  autocmd BufWritePre * let &backupext = '-' . strftime("%Y%m%d_%H%M")
augroup END
if has('win32') || has('win64')
  set backupdir=$VIM/backup
else
  set backupdir=$HOME/.vim/backup
endif

