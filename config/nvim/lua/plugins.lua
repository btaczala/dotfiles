local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

require("packer").startup(function()
	use("wbthomason/packer.nvim")

	use("nvim-telescope/telescope.nvim")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use("christoomey/vim-tmux-navigator")
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("famiu/feline.nvim")
	use("vmchale/just-vim")
	use("peterhoeg/vim-qml")
	use("famiu/bufdelete.nvim")
	use("rmagatti/auto-session")
	use("onsails/lspkind-nvim")
	use("rafamadriz/friendly-snippets")
	use({ "tpope/vim-dispatch", opt = true, cmd = { "Dispatch", "Make", "Focus", "Start" } })
	use({
		"AckslD/nvim-neoclip.lua",
		requires = { "tami5/sqlite.lua", module = "sqlite" },
		config = function()
			require("neoclip").setup()
		end,
	})
	use({ "akinsho/toggleterm.nvim" })
	use({ "norcalli/nvim-colorizer.lua" })
	use("rcarriga/nvim-notify")

	-- fzf
	use("vijaymarupudi/nvim-fzf")
	use("kyazdani42/nvim-web-devicons")
	use("junegunn/fzf")
	use("junegunn/fzf.vim")

	-- lsp
	use("neovim/nvim-lspconfig")
	use("nvim-lua/lsp-status.nvim")
	use("glepnir/lspsaga.nvim")
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-nvim-lsp")
	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")
	use("hrsh7th/cmp-buffer")
	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	})

	-- MacOS
	use("cormacrelf/dark-notify")

	-- Coding
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})

	use({
		"w0rp/ale",
		ft = { "sh", "zsh", "cpp", "bash", "cmake", "html", "markdown", "racket", "vim", "tex" },
		cmd = "ALEEnable",
		config = "vim.cmd[[ALEEnable]]",
	})

	use("liuchengxu/vista.vim")
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
	use("nvim-telescope/telescope-dap.nvim")
	use({ "mrjones2014/dash.nvim", requires = { "nvim-telescope/telescope.nvim" } })
	use({
		"Shatur/neovim-cmake",
		requires = { "skywind3000/asyncrun.vim", "mfussenegger/nvim-dap", "nvim-telescope/telescope.nvim" },
	})

	-- Git
	use("tpope/vim-fugitive")
	use({
		"lewis6991/gitsigns.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("gitsigns").setup()
		end,
	})

	-- colorschemes
	use("rafamadriz/neon")
	use("Pocco81/Catppuccino.nvim")
	use("marko-cerovac/material.nvim")
	use("folke/tokyonight.nvim")
	use("projekt0n/github-nvim-theme")
end)
