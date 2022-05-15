local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

require("packer").startup(function()
	use("wbthomason/packer.nvim")

	use("nvim-telescope/telescope.nvim")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use("nvim-telescope/telescope-live-grep-raw.nvim")
	use({ "nvim-telescope/telescope-ui-select.nvim" })
	use("christoomey/vim-tmux-navigator")
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("famiu/feline.nvim")
	use({
		"nvim-lualine/lualine.nvim",
		requires = {
			{
				"kyazdani42/nvim-web-devicons",
				opt = true,
			},
			"arkav/lualine-lsp-progress",
		},
	})
	use("SmiteshP/nvim-gps")
	use("vmchale/just-vim")
	use("peterhoeg/vim-qml")
	use("famiu/bufdelete.nvim")
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
	use({
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup()
		end,
	})
	use({
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	})

	use({
		"sidebar-nvim/sidebar.nvim",
		config = function()
			require("sidebar-nvim").setup({
				sections = { "datetime", "git", "symbols" },
				symbols = {
					icon = "ƒ",
				},
				buffers = {
					icon = "",
					ignored_buffers = {}, -- ignore buffers by regex
					sorting = "id", -- alternatively set it to "name" to sort by buffer name instead of buf id
					show_numbers = true, -- whether to also show the buffer numbers
				},
			})
		end,
	})
	use({
		"rmagatti/auto-session",
	})

	use({
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})

	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup({})
		end,
	})

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
	use({
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("trouble").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
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

	use("liuchengxu/vista.vim")
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
	use("nvim-telescope/telescope-dap.nvim")
	use({
		"Shatur/neovim-cmake",
		requires = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap", "nvim-telescope/telescope.nvim" },
	})
	use({ "ckipp01/nvim-jenkinsfile-linter", requires = { "nvim-lua/plenary.nvim" } })

	-- Git
	use("tpope/vim-fugitive")
	use({
		"lewis6991/gitsigns.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "+" },
				},
				numhl = true,
			})
		end,
	})
	use({
		"TimUntersberger/neogit",
		requires = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
		config = function()
			require("neogit").setup({
				disable_commit_confirmation = true,
				integrations = {
					diffview = true,
				},
			})
		end,
	})

	-- colorschemes
	use("rafamadriz/neon")
	use("Pocco81/Catppuccino.nvim")
	use("marko-cerovac/material.nvim")
	use("folke/tokyonight.nvim")
	use("projekt0n/github-nvim-theme")
	use("navarasu/onedark.nvim")
end)
