local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')
Plug 'nvim-lua/plenary.nvim'
Plug 'cormacrelf/dark-notify'
Plug 'nvim-telescope/telescope.nvim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'rafamadriz/neon'
Plug 'hoob3rt/lualine.nvim'
Plug 'folke/tokyonight.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'TimUntersberger/neogit'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'ms-jpq/coq_nvim'
Plug 'b3nj5m1n/kommentary'
Plug 'famiu/bufdelete.nvim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
vim.call('plug#end')
