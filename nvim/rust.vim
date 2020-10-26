autocmd FileType rust nnoremap <buffer><Leader>cf :RustFmt<CR>
autocmd BufRead,BufNewFile Cargo.toml,Cargo.lock,*.rs setlocal makeprg=cargo
autocmd BufRead,BufNewFile Cargo.toml,Cargo.lock,*.rs compiler cargo
let g:rustfmt_autosave = 1
