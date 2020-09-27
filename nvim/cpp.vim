autocmd FileType c,cpp nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp vnoremap <buffer><Leader>cf :ClangFormat<CR>
autocmd FileType c,cpp setlocal keywordprg=:Cppman
autocmd FileType c,cpp set makeprg=ninja\ -C\ build
