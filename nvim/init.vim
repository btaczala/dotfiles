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
set secure

let mapleader = ","
if has('mac')
    let g:python_host_prog='/usr/local/bin/python3'
    let g:python2_host_prog = '/usr/local/bin/python'
    let g:python3_host_prog = '/usr/local/bin/python3'
elseif has('win32')
    let g:python2_host_prog = 'C:\Python27\python.exe'
    let g:python3_host_prog = 'C:\Python38\python.exe'
endif
let $FZF_DEFAULT_COMMAND = 'rg --files --follow --glob "!.git/*" --glob "!build/*" --glob "!3rdParty*/*" '

let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsSnippetDirectories=["UltiSnips", $HOME.'/dotfiles/vim/my-snips']
let g:rg_command = 'rg --vimgrep -S'
if has('mac')
    let g:notes_directories = ['~/Library/Mobile\ Documents/com\~apple\~CloudDocs/Documents/notes']
endif
let g:notes_unicode_enabled = 0
let g:notes_tab_indents = 0

" Shfmt 4 spaces
let g:shfmt_extra_args = '-i 4'

" rust
let g:cargo_makeprg_params = 'build'

let g:fzf_preview_window = 'right:60%'

" remove trailing whitespaces
"autocmd BufWritePre * %s/\s\+$//e
autocmd FileType c,cpp nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp vnoremap <buffer><Leader>cf :ClangFormat<CR>
autocmd FileType qml nnoremap <Leader>cf :!qmlfmt -w %<CR>
autocmd FileType qml nnoremap <Leader>cs :Dispatch qmlscene %<CR><Paste>
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType cmake nnoremap <buffer><Leader>cf :!cmake-format -i %<CR>
autocmd FileType rust nnoremap <buffer><Leader>cf :RustFmt<CR>
autocmd FileType sh nnoremap <buffer><Leader>cf :Shfmt<CR>
autocmd FileType c,cpp setlocal keywordprg=:Cppman

set guifont=SauceCodePro\ Nerd\ Font\ Mono

source $HOME/dotfiles/nvim/languageclient.vim
source $HOME/dotfiles/nvim/lightline.vim
source $HOME/dotfiles/nvim/bindings.vim
source $HOME/dotfiles/nvim/fzf-branch-checkout.vim
