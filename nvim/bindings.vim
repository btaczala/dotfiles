" Mapping
nnoremap <leader>n :NERDTreeToggle <CR>
nnoremap <leader>f :Grepper<CR>
nnoremap <leader>b :Buffers <CR>
nnoremap <leader>a :Dispatch <CR>
nnoremap <Leader>q :Bdelete<CR>
nnoremap <Leader>g :Git<CR>
nnoremap <Leader>h :History:<CR>

map <C-P> :Files<CR>
map <C-B> :Buffers<CR>
map <F2> :bprevious<CR>
map <F3> :bnext<CR>
nmap <leader>cp :let @+ = expand("%")<CR>
nmap <leader>CP :let @+ = expand("%:p")<CR>
noremap <F5> :set list!<CR>
inoremap <F5> <C-o>:set list!<CR>
cnoremap <F5> <C-c>:set list!<CR>

" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
