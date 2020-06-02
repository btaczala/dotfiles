let g:ycm_global_ycm_extra_conf = '$HOME/dotfiles/ycm_extra_conf.py'
if has('mac')
    let g:ycm_clangd_binary_path = '/usr/local/Cellar/llvm/10.0.0_3/bin/clangd'
endif

function SetLSPShortcuts()
  nnoremap <leader>ld :YcmCompleter GoToDefinition<CR>
  nnoremap <leader>lD :YcmCompleter GoToDeclaration<CR>
  nnoremap <leader>ll :YcmCompleter GetDoc<CR>
  nnoremap <leader>lr :YcmCompleter GoToReferences<CR>
  nnoremap <leader>lf :YcmCompleter FixIt<CR>
endfunction()

augroup LSP
  autocmd!
  autocmd FileType cpp,c call SetLSPShortcuts()
augroup END
