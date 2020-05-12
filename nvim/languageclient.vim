" LSP
if has('mac')
    let g:LanguageClient_serverCommands = {
      \ 'cpp': ['/usr/local/bin/ccls', '--log-file=/tmp/ccls.log'],
      \ 'c': ['/usr/local/bin/ccls'],
      \ 'cmake': ['/usr/local/bin/cmake-language-server'],
      \ }
else
    let g:LanguageClient_serverCommands = {
      \ 'cpp': ['ccls', '--log-file=/tmp/ccls.log'],
      \ 'c': ['ccls', '--log-file=/tmp/ccls.log'],
      \ 'python': ['/usr/bin/pyls'],
      \ }
endif
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverStderr = '/tmp/clangd.stderr'
let g:deoplete#enable_at_startup = 1
set signcolumn=no
set completefunc=LanguageClient#complete
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

function SetLSPShortcuts()
  nnoremap <leader>ld :call LanguageClient#textDocument_definition()<CR>
  nnoremap <leader>ll :call LanguageClient#textDocument_hover()<CR>
  nnoremap <leader>lr :call LanguageClient#textDocument_rename()<CR>
  nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
  nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
  nnoremap <leader>lx :call LanguageClient#textDocument_references()<CR>
  nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>
  nnoremap <leader>lc :call LanguageClient#textDocument_completion()<CR>
  nnoremap <leader>lh :call LanguageClient#textDocument_hover()<CR>
  nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
  nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>
endfunction()

augroup LSP
  autocmd!
  autocmd FileType cpp,c call SetLSPShortcuts()
augroup END
