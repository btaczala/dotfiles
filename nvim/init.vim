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
set modelines=1
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.gcno,*.gcda,*.cpp.o,CMakeLists.txt.user
set wildignore+=*/build*/*
set splitright
set makeprg=ninja\ -C\ build

let mapleader = ","
if has('mac')
    let g:python_host_prog='/usr/local/bin/python3'
    let g:python2_host_prog = '/usr/local/bin/python'
    let g:python3_host_prog = '/usr/local/bin/python3'
endif
let $FZF_DEFAULT_COMMAND = 'rg --files --follow --glob "!.git/*" --glob "!build*/*"'

" Ycm
let g:ycm_confirm_extra_conf = 0
let g:ycm_server_log_level = 'debug'
let g:ycm_global_ycm_extra_conf = '~/dotfiles/ycm_extra_conf.py'
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsSnippetDirectories=["UltiSnips", $HOME.'/dotfiles/vim/my-snips']
let g:rg_command = 'rg --vimgrep -S'

" Shfmt 4 spaces
let g:shfmt_extra_args = '-i 4'

" rust
let g:cargo_makeprg_params = 'build'

let g:PaperColor_Theme_Options = {
  \   'theme': {
  \     'default': {
  \       'transparent_background': 1
  \     }
  \   }
  \ }
let g:lightline = {
      \ 'colorscheme': 'PaperColor',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \   'gitbranch': 'fugitive#head',
      \ }
      \ }

function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction


call plug#begin('~/.local/share/nvim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'arakashic/chromatica.nvim'
Plug 'roxma/vim-tmux-clipboard'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vhdirk/vim-cmake'
Plug 'richq/vim-cmake-completion'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --system-libclang --rust-completer --go-completer' }
Plug 'tpope/vim-dispatch'
Plug 'rhysd/vim-clang-format'
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'
Plug 'vim-scripts/a.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'altercation/vim-colors-solarized'
Plug 'peterhoeg/vim-qml'
Plug 'tpope/vim-fugitive'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'dylanaraps/wal.vim'
Plug 'xolox/vim-notes'
Plug 'xolox/vim-misc'
Plug 'markonm/traces.vim'
Plug 'z0mbix/vim-shfmt', { 'for': 'sh' }
Plug 'airblade/vim-gitgutter'
" for Bdelete
Plug 'moll/vim-bbye'
Plug 'luochen1990/rainbow'
Plug 'lyuts/vim-rtags'
Plug 'mhinz/vim-grepper'
Plug 'aklt/plantuml-syntax'
Plug 'mboughaba/i3config.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'NLKNguyen/papercolor-theme'

Plug 'itchyny/lightline.vim'
Plug 'lervag/vimtex'
Plug 'https://github.com/majutsushi/tagbar'

" Initialize plugin system
call plug#end()

"set t_Co=256
syntax enable
" Mapping
nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>n :NERDTreeToggle <CR>
nnoremap <leader>f :GrepperRg 
nnoremap <leader>b :Buffers <CR>
nnoremap <leader>a :Dispatch <CR>
"bbye
nnoremap <Leader>q :Bdelete<CR>
map <C-P> :FZF<CR>
map <C-B> :Buffers<CR>
map <F2> :bprevious<CR>
map <F3> :bnext<CR>
nmap <leader>cp :let @+ = expand("%")<CR>
noremap <F5> :set list!<CR>
inoremap <F5> <C-o>:set list!<CR>
cnoremap <F5> <C-c>:set list!<CR>

autocmd FileType c,cpp nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp vnoremap <buffer><Leader>cf :ClangFormat<CR>
autocmd FileType qml nnoremap <Leader>cf :!qmlfmt -w %<CR>
autocmd FileType qml nnoremap <Leader>cs :!qmlscene % -style material<CR><Paste>
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType cmake nnoremap <buffer><Leader>cf :!cmake-format -i %<CR>
autocmd FileType rust nnoremap <buffer><Leader>cf :RustFmt<CR>
autocmd FileType sh nnoremap <buffer><Leader>cf :Shfmt<CR>

colorscheme PaperColor
set exrc
if has('mac')
    let iterm_profile = $ITERM_PROFILE
    colorscheme PaperColor
    if iterm_profile == "dark"
        set background=dark
    else
        set background=light        " Set solarized background color
    endif
else
    let color = system('cat ~/.current_color')

    if color =~# "light"
        set background=light
    else
        set background=dark
    endif
endif
