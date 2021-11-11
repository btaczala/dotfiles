local g = vim.g -- a table to access global variables
local opt = vim.opt -- to set options

g.mapleader = ","

require("plugins")
require("options")
require("lsp")
require("mappings")
require("colors")
require("projects")
require("statusline")
require("debugging")
require("coding")
require("snippets")

-- treesitter
local ts = require("nvim-treesitter.configs")
ts.setup({ ensure_installed = "maintained", highlight = { enable = true } })

-- telescope
local actions = require("telescope.actions")
require("telescope").load_extension("neoclip")
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
		dash = {
			-- configure path to Dash.app if installed somewhere other than /Applications/Dash.app
			-- debounce while typing, in milliseconds, defaults to 750 (0.75 seconds)
			debounce = 750,
			-- map filetype strings to the keywords you've configured for docsets in Dash
			-- setting to false will disable filtering by filetype for that filetype
			-- filetypes not included in this table will not filter the query by filetype
			-- check lua/dash/utils/config.lua to see all defaults
			-- the values you pass for file_type_keywords are merged with the defaults
			-- to disable filtering for all filetypes,
			-- set file_type_keywords = false
			file_type_keywords = {
				dashboard = false,
				NvimTree = false,
				TelescopePrompt = false,
				terminal = false,
				packer = false,
				-- you can also do a string, for example,
				-- bash = 'sh'
			},
		},
	},
})

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost /Users/btaczala/dotfiles/config/nvim/lua/plugins.lua source <afile> | PackerInstall
  augroup end
]])

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost /Users/btaczala/dotfiles/installers/macos/Brewfile | Dispatch brew bundle --file /Users/btaczala/dotfiles/installers/macos/Brewfile
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
vim.api.nvim_command([[
    autocmd FileType qml nnoremap <Leader>qq :Dispatch qmlscene %<CR>
]])
