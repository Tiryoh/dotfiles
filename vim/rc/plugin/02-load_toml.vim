" Load toml file
let g:rc_dir = expand('~/.vim/rc')
let g:toml = g:rc_dir . '/dein.toml'
call dein#load_toml(g:toml,{'lazy': 0})
