local g = vim.g -- a table to access global variables
local opt = vim.opt -- to set options

g.mapleader = ","

require("plugins")
require("lsp")
require("mappings")
require("colors")
require("projects")
require("statusline")
require("debugging")
require("coding")
require("snippets")
require("options")

-- treesitter
local ts = require("nvim-treesitter.configs")
ts.setup({
	ensure_installed = { "c", "cpp", "lua", "rust", "cmake", "json", "json5", "python", "yaml", "zig" },
	sync_install = false,
	highlight = { enable = true },
})

-- telescope
local actions = require("telescope.actions")
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				-- To disable a keymap, put [map] = false
				-- So, to not map "<C-n>", just put
				["<C-n>"] = false,
				["<C-p>"] = false,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
			},
		},
	},
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
		},
	},
})
require("telescope").load_extension("neoclip")
require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost $HOME/dotfiles/config/nvim/lua/plugins.lua source <afile> | PackerInstall | PackerCompile
  augroup end
]])

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost $HOME/dotfiles/installers/macos/Brewfile | Dispatch brew bundle --file $HOME/dotfiles/installers/macos/Brewfile
  augroup end
]])

vim.api.nvim_exec(
	[[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
	false
)
vim.cmd([[
    au BufNewFile,BufRead Jenkinsfile setf groovy
]])
