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

let g:python_host_prog='/usr/bin/python3'
let mapleader = ","
let $FZF_DEFAULT_COMMAND = 'ag -g "" --ignore 3rdParty'

" airline
let g:airline_theme = 'distinguished'
let g:airline#extensions#tabline#enabled = 1
let g:airline_detect_modified=0
let g:airline_detect_paste=0
let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
let g:airline_section_c = '%F'
" Ycm
let g:ycm_confirm_extra_conf = 0
let g:ycm_server_log_level = 'debug'
let g:ycm_global_ycm_extra_conf = '~/dotfiles/ycm_extra_conf.py'
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsSnippetDirectories=["UltiSnips", $HOME.'/dotfiles/vim/my-snips']

call plug#begin('~/.local/share/nvim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'junegunn/fzf'
Plug 'wbthomason/buildit.nvim'
Plug 'arakashic/chromatica.nvim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'roxma/vim-tmux-clipboard'
Plug 'vhdirk/vim-cmake'
Plug 'Valloric/YouCompleteMe'
Plug 'tpope/vim-dispatch'
Plug 'rhysd/vim-clang-format'
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'
Plug 'vim-scripts/a.vim'
Plug 'morhetz/gruvbox'
Plug 'nanotech/jellybeans.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'alepez/vim-gtest'
Plug 'altercation/vim-colors-solarized'
Plug 'nightsense/seagrey'
Plug 'nightsense/plumber'

" Initialize plugin system
call plug#end()

set background=dark
"set background=light
set t_Co=256
colorscheme jellybeans
"colorscheme vrunchbang
syntax enable
"colorscheme solarized
" Mapping
nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>n :NERDTreeToggle <CR>
nnoremap <leader>f :set foldmethod=syntax <CR>
nnoremap <leader>b :Buffers <CR>
nnoremap <leader>c :cnext <CR>
map <C-P> :FZF<CR>
map <F2> :bprevious<CR>
map <F3> :bnext<CR>

autocmd FileType c,cpp nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp vnoremap <buffer><Leader>cf :ClangFormat<CR>