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
Plug 'pboettch/vim-cmake-syntax'
Plug 'tpope/vim-dispatch'
Plug 'rhysd/vim-clang-format'
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'
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
Plug 'mboughaba/i3config.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'arzg/vim-colors-xcode'
Plug 'itchyny/lightline.vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'xolox/vim-session'

Plug 'https://github.com/skywind3000/vim-cppman'
Plug 'blindFS/vim-taskwarrior'
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --clangd-completer --clang-completer'  }
Plug 'liuchengxu/vista.vim'

Plug 'rust-lang/rust.vim'
" color themes
Plug 'NLKNguyen/papercolor-theme'
Plug 'jsit/toast.vim'
Plug 'Luxed/ayu-vim'
Plug 'lervag/vimtex'

" c++
Plug 'octol/vim-cpp-enhanced-highlight'

" Initialize plugin system
call plug#end()
