" keybind
function! s:my_cr_func()
    let presentchar = getline(".")[col(".")-1]
    let prevchar = getline(".")[col(".")-2]
    if presentchar == "}" && prevchar == "{"
        return "\<CR>\<CR>\<UP>\<TAB>"
    else
        return "\<CR>"
    endif
endfunction
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
imap <expr><TAB> pumvisible() ? "\<C-n>"
\: neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"
imap <expr><CR> pumvisible() ? neocomplcache#close_popup() : <SID>my_cr_func()
xmap <C-k> <Plug>(neosnippet_expand_target)
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-l> neocomplcache#complete_common_string()
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplcache#close_popup()
inoremap <expr><C-e> neocomplcache#cancel_popup()
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"

