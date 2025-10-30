---@diagnostic disable: missing-fields
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`

if vim.g.vscode then
  local vscode = require 'vscode'
  vim.keymap.set('', '<Space>', '<Nop>')
  vim.g.mapleader = ' '
  vim.api.nvim_set_keymap('n', 'j', 'h', { noremap = true })
  vim.api.nvim_set_keymap('n', 'k', 'j', { noremap = true })
  vim.api.nvim_set_keymap('n', 'l', 'k', { noremap = true })
  vim.api.nvim_set_keymap('n', ';', 'l', { noremap = true })

  vim.api.nvim_set_keymap('v', 'j', 'h', { noremap = true })
  vim.api.nvim_set_keymap('v', 'k', 'j', { noremap = true })
  vim.api.nvim_set_keymap('v', 'l', 'k', { noremap = true })
  vim.api.nvim_set_keymap('v', ';', 'l', { noremap = true })
  -- vim.keymap.set('n', '<leader>ff', '<cmd>lua require("vscode").call("editor.action.formatSelection")<cr>')
  vim.keymap.set('n', '<leader>ff', function()
    vscode.call 'workbench.action.quickOpen'
  end)
  vim.keymap.set('n', '<leader>ww', function()
    vscode.call 'workbench.action.'
  end)
  vim.keymap.set('n', '<leader>jj', function()
    vscode.call 'cmake.build'
  end)
  return
end

require 'options'
require 'lazy-bootstrap'
require 'plugins'
require 'keymaps'

vim.api.nvim_create_augroup('CppFiles', { clear = true })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.qml' },
  callback = function()
    local path = vim.fn.expand '%:p'
    if string.sub(path, 1, #'/Users/bartek/Projects/inmusic/') == '/Users/bartek/Projects/inmusic/' then
      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>rp', '<cmd>OverseerRun evstylepreview <CR>', { noremap = true, silent = true })
    else
      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>rp', '<cmd>!qmlscene ' .. path .. '<CR>', { noremap = true, silent = true })
    end
  end,
  group = 'CppFiles',
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.scad' },
  callback = function()
    local U = require 'openscad.utilities'
    local builtin = require 'telescope.builtin'
    local path = U.openscad_nvim_root_dir .. U.path_sep .. 'help_source' .. U.path_sep .. 'tree'
    vim.keymap.set('n', '<leader>h', function()
      builtin.find_files { cwd = path }
    end, { desc = 'Search Openscad [h]elp' })
  end,
  group = 'CppFiles',
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.justfile' },
  command = 'set filetype=just',
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.slint' },
  command = 'set filetype=slint',
})

require 'cpp'
require 'lsp-config'
