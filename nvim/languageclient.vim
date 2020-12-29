function LC_maps()
    nmap <leader>ld <Plug>(coc-definition)
    nmap <leader>lr <Plug>(coc-rename)
    nmap <leader>lx <Plug>(coc-references)
    nmap <leader>lf <Plug>(coc-codeaction)
    nmap <leader>lq :call CocActionAsync('doHover')<CR>
    nmap <leader>la :CocCommand clangd.switchSourceHeader<CR>
    nmap <leader>ll :CocCommand workspace.showOutput<CR>
    nmap <leader>ls :CocList outline<CR>
    autocmd CursorHold * silent call CocActionAsync('highlight')
endfunction

autocmd FileType cpp,c,sh,cmake,rust call LC_maps()
