function LC_maps()
    nmap <leader>ld :YcmCompleter GoToDefinition<CR>
    nmap <leader>lD :YcmCompleter GoToDeclaration<CR>
    nmap <leader>lx :YcmCompleter GoToReferences<CR>
    nmap <leader>lf :YcmCompleter FixIt<CR>
    nmap <leader>la :YcmCompleter GoToInclude<CR>
    nmap <leader>lr :YcmCompleter RefactorRename 
endfunction

nmap <leader>v :Vista!!<CR>
nmap <leader>ls :BTags<CR>

autocmd FileType cpp,c,sh,cmake,rust call LC_maps()

let g:cpp_member_variable_highlight = 1
let g:cpp_experimental_template_highlight = 1
