source $HOME/dotfiles/nvim/plugins.vim
source $HOME/dotfiles/nvim/colors.vim

set smartindent
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set encoding=utf8

set nospell "no spell by default
set spelllang=en_us,pl
set spellfile=~/dotfiles/vim/en.utf-8.add
set nu
set rnu
set modeline
set modelines=0
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.gcno,*.gcda,*.cpp.o,CMakeLists.txt.user
set wildignore+=*/build*/*
set splitright
set makeprg=ninja\ -C\ build

syntax enable
set exrc

let mapleader = ","
if has('mac')
    let g:python_host_prog='/usr/local/bin/python3'
    let g:python2_host_prog = '/usr/local/bin/python'
    let g:python3_host_prog = '/usr/local/bin/python3'
endif
let $FZF_DEFAULT_COMMAND = 'rg --files --follow --glob "!.git/*" --glob "!build*/*" --glob "!3rdParty*/*" '

let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsSnippetDirectories=["UltiSnips", $HOME.'/dotfiles/vim/my-snips']
let g:rg_command = 'rg --vimgrep -S'

" Shfmt 4 spaces
let g:shfmt_extra_args = '-i 4'

" rust
let g:cargo_makeprg_params = 'build'


" remove trailing whitespaces
"autocmd BufWritePre * %s/\s\+$//e
autocmd FileType c,cpp nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp vnoremap <buffer><Leader>cf :ClangFormat<CR>
autocmd FileType qml nnoremap <Leader>cf :!qmlfmt -w %<CR>
autocmd FileType qml nnoremap <Leader>cs :!qmlscene % -style material<CR><Paste>
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType cmake nnoremap <buffer><Leader>cf :!cmake-format -i %<CR>
autocmd FileType rust nnoremap <buffer><Leader>cf :RustFmt<CR>
autocmd FileType sh nnoremap <buffer><Leader>cf :Shfmt<CR>


" LSP
if has('mac')
    let g:LanguageClient_serverCommands = {
      \ 'cpp': ['/usr/local/Cellar/llvm/9.0.1/bin/clangd'],
      \ 'c': ['/usr/local/Cellar/llvm/9.0.1/bin/clangd'],
      \ }
else
    let g:LanguageClient_serverCommands = {
      \ 'cpp': ['clangd'],
      \ 'c': ['clangd'],
      \ 'python': ['/usr/bin/pyls'],
      \ }
endif
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverStderr = '/tmp/clangd.stderr'
let g:deoplete#enable_at_startup = 1
set signcolumn=yes
set completefunc=LanguageClient#complete
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

let g:vista#renderer#enable_icon = 0
set guifont=SauceCodePro\ Nerd\ Font\ Mono

source $HOME/dotfiles/nvim/lightline.vim
source $HOME/dotfiles/nvim/bindings.vim
