---@diagnostic disable: missing-fields
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`

if vim.g.vscode then
  local vscode = require 'vscode'
  vim.keymap.set("", "<Space>", "<Nop>")
  vim.g.mapleader = " "
  vim.api.nvim_set_keymap('n', 'j', 'h', { noremap = true })
  vim.api.nvim_set_keymap('n', 'k', 'j', { noremap = true })
  vim.api.nvim_set_keymap('n', 'l', 'k', { noremap = true })
  vim.api.nvim_set_keymap('n', ';', 'l', { noremap = true })

  vim.api.nvim_set_keymap('v', 'j', 'h', { noremap = true })
  vim.api.nvim_set_keymap('v', 'k', 'j', { noremap = true })
  vim.api.nvim_set_keymap('v', 'l', 'k', { noremap = true })
  vim.api.nvim_set_keymap('v', ';', 'l', { noremap = true })
  -- vim.keymap.set('n', '<leader>ff', '<cmd>lua require("vscode").call("editor.action.formatSelection")<cr>')
  vim.keymap.set('n', '<leader>ff', function ()
      vscode.call 'workbench.action.quickOpen'
  end)
  vim.keymap.set('n', '<leader>ww', function ()
      vscode.call 'workbench.action.files.save'
  end)
  vim.keymap.set('n', '<leader>jj', function ()
      vscode.call 'cmake.build'
  end)
  return
end

require 'options'
require 'lazy-bootstrap'
require 'plugins'
require 'keymaps'

local function find_project_root()
  local patterns = { 'CMakeLists.txt', '.git' } -- Look for CMakeLists.txt or .git as root markers
  local root = vim.fs.find(patterns, { upward = true, stop = os.getenv 'HOME' })[1]
  if root then
    return vim.fs.dirname(root) -- Return the directory containing the root marker
  end
end

local function cmake_file_exists()
  local root_dir = find_project_root()
  if root_dir then
    return vim.fs.find('CMakeLists.txt', { path = root_dir })
  end
  return false
end

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

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    if cmake_file_exists() then
      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jj', '<cmd>CMakeBuild<CR>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ja', '<cmd>CMakeOpenExecutor<CR>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jc', '<cmd>CMakeGenerate<CR>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jr', '<cmd>CMakeRun<CR>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jd', '<cmd>CMakeDebug<CR>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jo', '<cmd>CMakeOpenRunner<CR>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jt', '<cmd>CMakeRunTest<CR>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>rr', '<cmd>CMakeRun<CR>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>rd', '<cmd>CMakeDebug<CR>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>rss', '<cmd>CMakeTargetSetting<CR>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>rst', '<cmd>CMakeSelectLaunchTarget<CR>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>rsb', '<cmd>CMakeSelectBuildTarget<CR>', { noremap = true, silent = true })
    end
  end,
})

vim.api.nvim_set_keymap('n', '<leader>ww', ':w!<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>g', ':Git<CR>', { noremap = true })
