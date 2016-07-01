set nocompatible               " be iMproved
filetype off                   " required!
syntax on

set hlsearch 
set incsearch
set laststatus=2
set colorcolumn=120
set hidden
"let g:airline_theme = 'wombat'
let g:airline_theme = 'distinguished'
let g:airline#extensions#tabline#enabled = 1
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
let g:cmake_build_type = 'Debug'
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:notes_directories = ['~/notes']
let g:ycm_confirm_extra_conf = 0
let g:BufKillOverrideCtrlCaret = 1
let g:ycm_server_log_level = 'debug'
let mapleader = ","
set smartindent
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
" no spell by default
set nospell
set spelllang=en_us,pl
set nu
set modeline
set modelines=5
"set fillchars+=vert:│
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.gcno,*.gcda,*.cpp.o,CMakeLists.txt.user
set wildignore+=*/build/*,*/3rdParty/*


au BufRead,BufNewFile *mutt* set filetype=mail
au BufRead,BufNewFile *muttrc* set filetype=muttrc
au BufRead,BufNewFile *vimpager* set nospell
autocmd BufRead,BufNewFile *.qml setfiletype qml
autocmd BufRead,BufNewFile *.go setfiletype go
autocmd FileType mail set spell
set spellfile=~/dotfiles/vim/en.utf-8.add

let g:ycm_global_ycm_extra_conf = '~/dotfiles/ycm_extra_conf.py'
syntax enable
" Use the right side of the screen
let g:buffergator_viewport_split_policy = 'R'

call plug#begin()

" My Plugins here:
"
Plug 'kien/ctrlp.vim'
Plug 'idbrii/vim-man'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Valloric/YouCompleteMe'
Plug 'bling/vim-bufferline'
Plug 'junegunn/fzf.vim'
Plug 'Yggdroot/indentLine'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'drmikehenry/vim-headerguard'
Plug 'vim-scripts/a.vim'
Plug 'vhdirk/vim-cmake'
Plug '29decibel/codeschool-vim-theme'
Plug 'fatih/vim-go'
Plug 'peterhoeg/vim-qml'
Plug 'majutsushi/tagbar'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'rking/ag.vim'
Plug 'severin-lemaignan/vim-minimap'
Plug 'sjbach/lusty'
Plug 'rhysd/vim-clang-format'
Plug 'rbgrouleff/bclose.vim'
Plug 'qpkorr/vim-bufkill'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'Matt-Deacalion/vim-systemd-syntax'
Plug 'Shougo/neocomplete.vim'
Plug 'kergoth/vim-bitbake'

call plug#end()
filetype plugin indent on     " required! 
set background=dark
colorscheme burnttoast256

" underline spelling mistakes
hi clear SpellBad
hi SpellBad cterm=underline

" Mapping
nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>b :TagbarToggle<CR>
nnoremap <leader>n :NERDTreeToggle <CR>
nnoremap <leader>f :set foldmethod=syntax <CR>
map <F2> :bprevious<CR>
map <F3> :bnext<CR>
map <F9> :Dispatch -j9<CR>

autocmd FileType c,cpp nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp vnoremap <buffer><Leader>cf :ClangFormat<CR>
"Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
