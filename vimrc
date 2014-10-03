
set nocompatible               " be iMproved
filetype off                   " required!
syntax on
set rtp+=~/.vim/bundle/Vundle.vim

set hlsearch 
set incsearch
set laststatus=2
let g:airline_theme = 'wombat'
let g:airline#extensions#tabline#enabled = 1
let g:loaded_dispatch = 0
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
let g:cmake_build_type = 'Debug'
set smartindent
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set spell
set spelllang=en_us,pl
au BufRead,BufNewFile *mutt* set filetype=mail
autocmd FileType mail set spell
set spellfile=~/ownCloud/en.utf-8.add

let g:ycm_global_ycm_extra_conf = '~/dotfiles/ycm_extra_conf.py'
syntax enable

call vundle#begin()

" My Plugins here:
"
Plugin 'gmarik/Vundle.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'bling/vim-airline'
Plugin 'Valloric/YouCompleteMe'
Plugin 'bling/vim-bufferline'
Plugin 'Yggdroot/indentLine'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'mhinz/vim-startify'
Plugin 'altercation/vim-colors-solarized'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'
Plugin 'drmikehenry/vim-headerguard'
Plugin 'vim-scripts/a.vim'
Plugin 'vhdirk/vim-cmake'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'vim-scripts/lbdbq'
Plugin 'morhetz/gruvbox'
call vundle#end() 
filetype plugin indent on     " required! 
"
" Brief help
" :PluginList          - list configured bundles
" :PluginInstall(!)    - install(update) bundles
" :PluginSearch(!) foo - search(or refresh cache first) for foo
" :PluginClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Plugin command are not allowed..
set background=dark
colorscheme gruvbox
