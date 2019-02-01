" Load toml file
let g:rc_dir = expand('~/.vim/rc')
let g:toml = g:rc_dir . '/dein.toml'
let g:lazy_toml = g:rc_dir . '/dein_lazy.toml'
call dein#load_toml(g:toml,{'lazy': 0})
call dein#load_toml(g:lazy_toml,{'lazy': 1})
