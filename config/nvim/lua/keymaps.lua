vim.api.nvim_set_keymap('n', 'j', 'h', { noremap = true })
vim.api.nvim_set_keymap('n', 'k', 'j', { noremap = true })
vim.api.nvim_set_keymap('n', 'l', 'k', { noremap = true })
vim.api.nvim_set_keymap('n', ';', 'l', { noremap = true })

vim.api.nvim_set_keymap('v', 'j', 'h', { noremap = true })
vim.api.nvim_set_keymap('v', 'k', 'j', { noremap = true })
vim.api.nvim_set_keymap('v', 'l', 'k', { noremap = true })
vim.api.nvim_set_keymap('v', ';', 'l', { noremap = true })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<C-;>', require('smart-splits').move_cursor_right)

vim.keymap.set('n', '<A-j>', require('smart-splits').resize_left)
vim.keymap.set('n', '<A-k>', require('smart-splits').resize_down)
vim.keymap.set('n', '<A-l>', require('smart-splits').resize_up)
vim.keymap.set('n', '<A-;>', require('smart-splits').resize_right)

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>oo', '<cmd>OverseerToggle<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

local bm = require 'bookmarks'
vim.keymap.set('n', '<leader>mm', bm.bookmark_toggle, { desc = 'Toggle Book[m]ark' })
vim.keymap.set('n', '<leader>ms', '<cmd>Telescope bookmarks list<CR>', { desc = '[S]how bookmarks' })
vim.keymap.set('n', '<leader>mx', bm.bookmark_clean, { desc = 'Bookmark Clean' })
vim.keymap.set('n', '<leader>mn', bm.bookmark_next, { desc = 'Bookmark [N]ext' })
vim.keymap.set('n', '<leader>mp', bm.bookmark_next, { desc = 'Bookmark [P]revious' })
vim.keymap.set('n', '<leader>ma', bm.bookmark_ann, { desc = 'Bookmark [A]nnotate' })
vim.keymap.set('n', '<leader>mX', bm.bookmark_clear_all, { desc = 'Bookmark Clear All' })

vim.keymap.set('n', '<leader>cP', ':let @* = expand("%:p")<CR>', { noremap = true })
vim.keymap.set('n', '<leader>cp', ':let @* = expand("%")<CR>', { noremap = true })
