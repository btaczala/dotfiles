let g:LanguageClient_serverStderr = '/tmp/clangd.stderr'
let g:LanguageClient_serverCommands = {
  \ 'cpp': ['/usr/local/Cellar/llvm/10.0.0_3/bin/clangd'],
  \ 'c': ['/usr/local/Cellar/llvm/10.0.0_3/bin/clangd'],
  \ 'sh': ['bash-language-server', 'start'],
  \ }

let g:deoplete#enable_at_startup = 1

function SetLSPShortcuts()
  nnoremap <leader>ld :call LanguageClient#textDocument_definition()<CR>
  nnoremap <leader>lr :call LanguageClient#textDocument_rename()<CR>
  nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
  nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
  nnoremap <leader>lx :call LanguageClient#textDocument_references()<CR>
  nnoremap <leader>la :call LanguageClient#textDocument_codeAction()<CR>
  nnoremap <leader>lc :call LanguageClient#textDocument_completion()<CR>
  nnoremap <leader>lh :call LanguageClient#textDocument_hover()<CR>
  nnoremap <leader>s :call LanguageClient_textDocument_documentSymbol()<CR>
  nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>
endfunction()

augroup LSP
  autocmd!
  autocmd FileType cpp,c,sh call SetLSPShortcuts()
augroup END
