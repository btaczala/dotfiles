local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')
Plug 'nvim-lua/plenary.nvim'
if vim.fn.has("mac") == 1 then
  Plug 'cormacrelf/dark-notify'
end
Plug 'nvim-telescope/telescope.nvim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'hoob3rt/lualine.nvim'
Plug 'folke/tokyonight.nvim'
-- fzf
Plug 'vijaymarupudi/nvim-fzf'
Plug 'ibhagwan/fzf-lua'
Plug 'kyazdani42/nvim-web-devicons'
-- lsp 
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'glepnir/lspsaga.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-buffer'

Plug 'b3nj5m1n/kommentary'
Plug 'famiu/bufdelete.nvim'
Plug 'tpope/vim-fugitive'
Plug 'rmagatti/auto-session'

-- colorschemes
Plug 'rafamadriz/neon'
Plug 'Pocco81/Catppuccino.nvim'
Plug 'marko-cerovac/material.nvim'
Plug 'folke/tokyonight.nvim'
Plug 'projekt0n/github-nvim-theme'

-- C++
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'ilyachur/cmake4vim'
Plug 'tpope/vim-dispatch'
Plug 'peterhoeg/vim-qml'
vim.call('plug#end')
