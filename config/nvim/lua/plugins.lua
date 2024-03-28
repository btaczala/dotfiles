local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

require("packer").startup(function()
	use("wbthomason/packer.nvim")

	use("nvim-telescope/telescope.nvim")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use("nvim-telescope/telescope-live-grep-args.nvim")
	use({ "nvim-telescope/telescope-ui-select.nvim" })
	use({
		"mrjones2014/smart-splits.nvim",
		config = function()
			require("smart-splits").setup()
		end,
	})

	use("p00f/clangd_extensions.nvim")
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
	use("lvimuser/lsp-inlayhints.nvim")

	use("RaafatTurki/hex.nvim")
	use("SmiteshP/nvim-gps")
	use("vmchale/just-vim")
	use("peterhoeg/vim-qml")
	use("famiu/bufdelete.nvim")
	use("onsails/lspkind-nvim")
	use("rafamadriz/friendly-snippets")
	use("SirVer/ultisnips")
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
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})
	use("dcharbon/vim-flatbuffers")
	use({
		"gbprod/yanky.nvim",
		config = function()
			require("yanky").setup({})
		end,
	})

	use({
		"folke/zen-mode.nvim",
		config = function()
			require("zen-mode").setup({})
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
		"SmiteshP/nvim-navic",
		requires = "neovim/nvim-lspconfig",
	})

	use({
		"rmagatti/goto-preview",
		config = function()
			require("goto-preview").setup({})
		end,
	})

	use({
		"SmiteshP/nvim-navbuddy",
		requires = {
			"neovim/nvim-lspconfig",
			"SmiteshP/nvim-navic",
			"MunifTanjim/nui.nvim",
			"numToStr/Comment.nvim", -- Optional
			"nvim-telescope/telescope.nvim", -- Optional
		},
		config = function()
			require("nvim-navbuddy").setup({})
		end,
	})

	-- MacOS
	use("f-person/auto-dark-mode.nvim")

	-- Coding
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
	use({
		"ThePrimeagen/refactoring.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
		config = function()
			require("refactoring").setup({})
		end,
	})

	use("liuchengxu/vista.vim")
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
	use("nvim-telescope/telescope-dap.nvim")
	use({ "ckipp01/nvim-jenkinsfile-linter", requires = { "nvim-lua/plenary.nvim" } })
	use("Shatur/neovim-tasks")
	use("Civitasv/cmake-tools.nvim")
	use("stevearc/overseer.nvim")

	use("vim-test/vim-test")

	-- Git
	use("tpope/vim-fugitive")
	use("FabijanZulj/blame.nvim")
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
				mappings = {
					popup = {
						["l"] = false,
					},
				},
			})
		end,
	})

	-- colorschemes
	use("tinted-theming/base16-vim")
	use("navarasu/onedark.nvim")

	-- presentations
	use({ "vim-pandoc/vim-pandoc" })
	use({ "vim-pandoc/vim-pandoc-syntax" })

	use({
		"nvim-orgmode/orgmode",
		config = function()
			require("orgmode").setup_ts_grammar()
			require("orgmode").setup({})
		end,
	})
end)
