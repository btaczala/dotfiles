let g:ycm_confirm_extra_conf = 0
function LC_maps()
    nmap <silent>ld <Plug>(coc-definition)
    nmap <leader>lr <Plug>(coc-rename)
    nmap <leader>lx <Plug>(coc-references)
    nmap <leader>la <Plug>(coc-codeaction)
    nmap <leader>lh :call CocActionAsync('doHover')<CR>
    nmap <leader>ll :CocCommand workspace.showOutput<CR>
    nmap <leader>ls :CocList outline<CR>
    autocmd CursorHold * silent call CocActionAsync('highlight')
endfunction

autocmd FileType cpp,c call LC_maps()
