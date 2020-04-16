" Mapping
nnoremap <leader>g :call LanguageClient_textDocument_definition()<CR>
nnoremap <leader>n :NERDTreeToggle <CR>
nnoremap <leader>f :GrepperAg 
nnoremap <leader>b :Buffers <CR>
nnoremap <leader>a :Dispatch <CR>
nnoremap <leader>t :TagbarToggle <CR>
nnoremap <Leader>q :Bdelete<CR>
nnoremap <Leader>s :Vista finder<CR>

map <C-P> :Files<CR>
map <C-B> :Buffers<CR>
map <F2> :bprevious<CR>
map <F3> :bnext<CR>
nmap <leader>cp :let @+ = expand("%")<CR>
noremap <F5> :set list!<CR>
inoremap <F5> <C-o>:set list!<CR>
cnoremap <F5> <C-c>:set list!<CR>

