return require('packer').startup(function()
    use 'wbthomason/packer.nvim'

    use 'nvim-telescope/telescope.nvim'
    use 'christoomey/vim-tmux-navigator'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'famiu/feline.nvim'
    use 'vmchale/just-vim'
    use 'peterhoeg/vim-qml'
    use 'famiu/bufdelete.nvim'
    use 'rmagatti/auto-session'
    use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}

    -- fzf
    use 'vijaymarupudi/nvim-fzf'
    use 'kyazdani42/nvim-web-devicons'
    use 'junegunn/fzf'
    use 'junegunn/fzf.vim'

    -- lsp 
    use 'neovim/nvim-lspconfig'
    use 'nvim-lua/lsp-status.nvim'
    use 'glepnir/lspsaga.nvim'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use 'hrsh7th/cmp-buffer'

    -- MacOS
    use 'cormacrelf/dark-notify'

    -- Coding
    use 'b3nj5m1n/kommentary'
    use {
      'w0rp/ale',
      ft = {'sh', 'zsh', 'bash', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex'},
      cmd = 'ALEEnable',
      config = 'vim.cmd[[ALEEnable]]'
    }
    use 'liuchengxu/vista.vim'
    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
    use 'ilyachur/cmake4vim'

    -- Git
    use 'tpope/vim-fugitive'
    use {
      'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
      config = function() require('gitsigns').setup() end
    }

    -- colorschemes
    use 'rafamadriz/neon'
    use 'Pocco81/Catppuccino.nvim'
    use 'marko-cerovac/material.nvim'
    use 'folke/tokyonight.nvim'
    use 'projekt0n/github-nvim-theme'
end)
