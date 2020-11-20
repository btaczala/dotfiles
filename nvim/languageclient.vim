let g:ycm_confirm_extra_conf = 0
function LC_maps()
    nnoremap <leader>ld :YcmCompleter GoTo<CR>
    nnoremap <leader>lr :YcmCompleter RefactorRename
    nnoremap <leader>ls :YcmCompleter GoToSymbol
  "nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
  nnoremap <leader>lx :YcmCompleter GoToReferences<CR>
  "nnoremap <leader>lx :call LanguageClient#textDocument_references()<CR>
  "nnoremap <leader>la :call LanguageClient#textDocument_codeAction()<CR>
  "nnoremap <leader>lc :call LanguageClient#textDocument_completion()<CR>
  "nnoremap <leader>lh :call LanguageClient#textDocument_hover()<CR>
  "nnoremap <leader>s :call LanguageClient_textDocument_documentSymbol()<CR>
  "nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>
  "nnoremap <leader>ll :call LanguageClient#debugInfo()<CR>
endfunction

autocmd FileType cpp call LC_maps()
