local g = vim.g -- a table to access global variables
local opt = vim.opt -- to set options

g.mapleader = ","

require('plugins')
require('options')
require('mappings')
require('colors')
require('lsp')

-- treesitter
local ts = require("nvim-treesitter.configs")
ts.setup({ ensure_installed = "maintained", highlight = { enable = true } })

-- neogit
local neogit = require('neogit')
neogit.setup {}

-- kommentary
require('kommentary.config').configure_language("cpp", {
    prefer_single_line_comments = true,
})

-- telescope
local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        -- To disable a keymap, put [map] = false
        -- So, to not map "<C-n>", just put
        ["<C-n>"] = false,
        ["<C-p>"] = false,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous
      }
    }
  }
}
