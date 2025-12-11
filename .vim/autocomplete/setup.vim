so ~/.vim/autocomplete/window.vim
autocmd TextChangedI * call OnType()
autocmd BufReadPost,BufWritePost,BufEnter * call Reload()
hi PmenuSel        guifg=#d4e0ff guibg=#2048ff ctermfg=252 ctermbg=17
hi Pmenu     guifg=#000000 guibg=#5fd7ff ctermfg=252 ctermbg=21
inoremap <expr> <UP> empty(popup_getpos(g:wind)) == 0 ? MenuUp() : "<UP>"
inoremap <expr> <DOWN> empty(popup_getpos(g:wind)) == 0 ? MenuDown() : "<DOWN>"
inoremap <expr> <CR> empty(popup_getpos(g:wind)) == 0 ? MenuSelect() : "<CR>"
inoremap <expr> <Tab> empty(popup_getpos(g:wind)) == 0 ? MenuTab() : "<Tab>"
