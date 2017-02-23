set nocompatible               " be iMproved
filetype off                   " required!
syntax on
set guifont=Hack

set exrc

set hlsearch
set incsearch
set laststatus=2
set colorcolumn=120
set hidden
set smartindent
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab

set nospell "no spell by default
set spelllang=en_us,pl
set spellfile=~/dotfiles/vim/en.utf-8.add
set nu
set rnu
set modeline
set modelines=5
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.gcno,*.gcda,*.cpp.o,CMakeLists.txt.user
set wildignore+=*/build*/*

" Global
let mapleader = ","
let g:BufKillOverrideCtrlCaret = 1
" airline
let g:airline_theme = 'distinguished'
let g:airline#extensions#tabline#enabled = 1
" Ycm
let g:ycm_confirm_extra_conf = 0
let g:ycm_server_log_level = 'debug'
let g:ycm_global_ycm_extra_conf = '~/dotfiles/ycm_extra_conf.py'
" Session control
let g:session_autosave = 'no'
let g:session_autoload = 'no'

let g:ycm_python_binary_path = '/usr/bin/python3'

" Bookmarks
let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1

" 
let g:goyo_width = 140
" Close NERDTree window

au BufRead,BufNewFile *mutt* set filetype=mail
au BufRead,BufNewFile *muttrc* set filetype=muttrc
autocmd BufRead,BufNewFile *.qml setfiletype qml
autocmd BufRead,BufNewFile *.go setfiletype go
autocmd FileType mail set spell

syntax enable
" Use the right side of the screen
let g:buffergator_viewport_split_policy = 'R'

call plug#begin()

" My Plugins here:
"
Plug 'idbrii/vim-man'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Valloric/YouCompleteMe'
Plug 'bling/vim-bufferline'
Plug 'Yggdroot/indentLine'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'vim-scripts/a.vim'
Plug 'vhdirk/vim-cmake'
Plug 'rhysd/vim-clang-format'
Plug 'rbgrouleff/bclose.vim'
Plug 'qpkorr/vim-bufkill'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'Matt-Deacalion/vim-systemd-syntax'
Plug 'Shougo/neocomplete.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'xolox/vim-session'
Plug 'xolox/vim-misc'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'airblade/vim-gitgutter'
Plug 'vim-scripts/headerguard'
Plug 'tmux-plugins/vim-tmux'
Plug 'junegunn/fzf.vim'
Plug 'richq/vim-cmake-completion'
Plug 'alepez/vim-gtest'
" Distract free mode
Plug 'junegunn/goyo.vim'

Plug 'hdima/python-syntax'
" colorschemes
Plug 'agude/vim-eldar'
Plug 'albertocg/contrastneed-theme'
Plug 'crater2150/vim-theme-chroma'

" Snippets
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsSnippetDirectories=["UltiSnips", "my-snips"]

call plug#end()
filetype plugin indent on     " required!
set background=dark
colorscheme jellybeans

" underline spelling mistakes
hi clear SpellBad
hi SpellBad cterm=underline

" Mapping
nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>n :NERDTreeToggle <CR>
"nnoremap <leader>f :set foldmethod=syntax <CR>
map <C-P> :FZF<CR>
map <F2> :bprevious<CR>
map <F3> :bnext<CR>
map <F9> :Dispatch -j9<CR>

autocmd FileType c,cpp nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp vnoremap <buffer><Leader>cf :ClangFormat<CR>
"Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

set secure
