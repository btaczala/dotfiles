function LC_coc_maps()
    nmap <leader>ld <Plug>(coc-definition)
    nmap <leader>lD <Plug>(coc-implementation)
    nmap <leader>lx <Plug>(coc-references)
    nmap <leader>lf <Plug>(coc-codeaction)
    nmap <leader>la :CocCommand clangd.switchSourceHeader<CR>
    nmap <leader>lr <Plug>(coc-rename)
    nmap <leader>ls :CocList outline<CR>
endfunction

function LC_maps()
    nmap <leader>ld :YcmCompleter GoToDefinition<CR>
    nmap <leader>lD :YcmCompleter GoToDeclaration<CR>
    nmap <leader>lx :YcmCompleter GoToReferences<CR>
    nmap <leader>lf :YcmCompleter FixIt<CR>
    nmap <leader>la :YcmCompleter GoToInclude<CR>
    nmap <leader>lr :YcmCompleter RefactorRename 
endfunction

nmap <leader>v :Vista!!<CR>

autocmd FileType cpp,c,sh,cmake,rust,zig call LC_coc_maps()
autocmd BufNewFile,BufRead *.zig set filetype=zig

let g:cpp_member_variable_highlight = 1
let g:cpp_experimental_template_highlight = 1

let g:ycm_filetype_whitelist = {'c': 1,'cpp':1}
let g:ycm_language_server =
  \ [
  \{
  \     'name': 'zls',
  \     'filetypes': [ 'zig' ],
  \     'cmdline': [ '/Users/bartektaczala/dev/zig/zls/zig-out/bin/zls' ]
  \    }
  \ ]
