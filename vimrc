set nocompatible               " be iMproved
filetype off                   " required!
syntax on

set hlsearch 
set incsearch
set laststatus=2
let g:airline_theme = 'wombat'
let g:loaded_dispatch = 0
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
set smartindent
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set background=dark

let g:ycm_global_ycm_extra_conf = '~/dotfiles/ycm_extra_conf.py'
syntax enable

call vundle#rc()

" My Bundles here:
"
Bundle 'kien/ctrlp.vim'
Bundle 'bling/vim-airline'
Bundle 'Valloric/YouCompleteMe'
Bundle 'bling/vim-bufferline'
Bundle 'Yggdroot/indentLine'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'mhinz/vim-startify'
Bundle 'altercation/vim-colors-solarized'
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "garbas/vim-snipmate"
Bundle 'honza/vim-snippets'
Bundle 'drmikehenry/vim-headerguard'
Bundle 'vim-scripts/a.vim'
filetype plugin indent on     " required! 
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..
