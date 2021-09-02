local g = vim.g -- a table to access global variables
local opt = vim.opt -- to set options

g.mapleader = ","
vim.g.coq_settings = {
  auto_start = 'shut-up',
  keymap = {
    recommended = true,
    jump_to_mark = ''
  }
}
require('plugins')
require('options')
require('lsp')
require('mappings')
require('colors')
require('projects')

-- treesitter
local ts = require("nvim-treesitter.configs")
ts.setup({ ensure_installed = "maintained", highlight = { enable = true } })

-- neogit
local neogit = require('neogit')
neogit.setup {}

-- kommentary
--
vim.g.kommentary_create_default_mappings = false
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
require('auto-session').setup()
require'lspsaga'.init_lsp_saga()
g.cmake_build_dir_prefix = "build-"
g.cmake_usr_args = "-GNinja"
g.cmake_compile_commands = true
g.cmake_compile_commands_link = "./"
