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
set splitright

let g:python_host_prog='/usr/bin/python3'
let mapleader = ","
let $FZF_DEFAULT_COMMAND = 'rg --files --follow --glob "!.git/*"'

" airline
let g:airline_theme = 'wombat'
let g:airline_skip_empty_sections = 1
let g:airline_powerline_fonts = 1
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

let g:ackprg = "ag --vimgrep"

call plug#begin('~/.local/share/nvim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'wbthomason/buildit.nvim'
Plug 'arakashic/chromatica.nvim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'roxma/vim-tmux-clipboard'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vhdirk/vim-cmake'
Plug 'richq/vim-cmake-completion'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --system-libclang' }
Plug 'tpope/vim-dispatch'
Plug 'rhysd/vim-clang-format'
Plug 'honza/vim-snippets'
Plug 'lvht/fzf-mru'
Plug 'SirVer/ultisnips'
Plug 'vim-scripts/a.vim'
Plug 'morhetz/gruvbox'
Plug 'nanotech/jellybeans.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'alepez/vim-gtest'
Plug 'altercation/vim-colors-solarized'
Plug 'nightsense/seagrey'
Plug 'nightsense/plumber'
Plug 'kovetskiy/sxhkd-vim'
Plug 'moll/vim-bbye'
Plug 'peterhoeg/vim-qml'
Plug 'tpope/vim-fugitive'
Plug 'lyuts/vim-rtags'
Plug 'w0ng/vim-hybrid'
Plug 'mileszs/ack.vim'
Plug 'mfukar/robotframework-vim'
Plug 'moll/vim-bbye'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'MattesGroeger/vim-bookmarks'

" Initialize plugin system
call plug#end()

"set t_Co=256
syntax enable
" Mapping
nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>n :NERDTreeToggle <CR>
nnoremap <leader>f :set foldmethod=syntax <CR>
nnoremap <leader>b :Buffers <CR>
nnoremap <leader>c :cnext <CR>
nnoremap <Leader>q :Bdelete<CR>
map <C-P> :FZF<CR>
map <F2> :bprevious<CR>
map <F3> :bnext<CR>

autocmd FileType c,cpp nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp vnoremap <buffer><Leader>cf :ClangFormat<CR>

set exrc

let g:hybrid_custom_term_colors = 1
let g:hybrid_reduced_contrast = 1 " Remove this line if using the default palette.
set background=dark
colorscheme hybrid

" cppman 
command! -nargs=+ Cppman silent! call system("tmux split-window cppman " . expand(<q-args>))
autocmd FileType cpp nnoremap <silent><buffer> K <Esc>:Cppman <cword><CR>
