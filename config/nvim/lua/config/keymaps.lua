vim.g.mapleader = ' '

vim.keymap.set('n', 'ff', function() require('telescope.builtin').find_files() end, { desc = 'Find files' })
vim.keymap.set('n', '<leader><leader>', function() require('telescope.builtin').buffers() end, { desc = 'Telescope buffers' })

vim.keymap.set({'n', 'v'}, 'j', 'h')
vim.keymap.set({'n', 'v'}, 'k', 'j')
vim.keymap.set({'n', 'v'}, 'l', 'k')
vim.keymap.set({'n', 'v'}, ';', 'l')

vim.keymap.set('n', '<leader>ww', '<cmd>write<cr>')


vim.keymap.set('n', '<leader>lf', function() vim.lsp.buf.format() end, { desc = 'LSP format buffer' })
vim.keymap.set({'n', 'v'}, '<leader>la', function() vim.lsp.buf.code_action() end, { desc = 'LSP code action' })
vim.keymap.set('n', '<leader>ld', function() vim.lsp.buf.definition() end, { desc = 'LSP go to definition' })
vim.keymap.set('n', '<leader>lx', function() vim.lsp.buf.rename() end, { desc = 'LSP rename' })
vim.keymap.set('n', '<leader>lD', function() vim.lsp.buf.declaration() end, { desc = 'LSP go to declaration' })
vim.keymap.set('n', '<leader>ls', function() require('telescope.builtin').lsp_document_symbols() end, { desc = 'LSP document symbols' })
vim.keymap.set('n', '<leader>lh', '<cmd>ClangdSwitchSourceHeader<cr>', { desc = 'Clangd switch header/source' })

vim.keymap.set('n', '<leader>cp', function()
    local git_root = vim.fn.systemlist('git -C ' .. vim.fn.shellescape(vim.fn.expand('%:p:h')) .. ' rev-parse --show-toplevel')[1]
    local full = vim.fn.expand('%:p')
    vim.fn.setreg('+', git_root and full:sub(#git_root + 2) or full)
end, { desc = 'Copy git-relative path to clipboard' })
vim.keymap.set('n', '<leader>cP', function() vim.fn.setreg('+', vim.fn.expand('%:p')) end, { desc = 'Copy full path to clipboard' })

vim.keymap.set('n', '<leader>d', function() vim.diagnostic.open_float() end, { desc = 'Show diagnostics' })
vim.keymap.set('n', '<leader>qq', function() vim.diagnostic.setqflist() end, { desc = 'Diagnostics to quickfix' })

vim.keymap.set('n', ']h', function() require('gitsigns').next_hunk() end, { desc = 'Next git hunk' })
vim.keymap.set('n', '[h', function() require('gitsigns').prev_hunk() end, { desc = 'Prev git hunk' })
vim.keymap.set('n', '<leader>hs', function() require('gitsigns').stage_hunk() end, { desc = 'Stage hunk' })
vim.keymap.set('v', '<leader>hs', function() require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { desc = 'Stage hunk (selection)' })
vim.keymap.set('n', '<leader>hu', function() require('gitsigns').undo_stage_hunk() end, { desc = 'Undo stage hunk' })
vim.keymap.set('n', '<leader>hr', function() require('gitsigns').reset_hunk() end, { desc = 'Reset hunk' })
vim.keymap.set('n', '<leader>hp', function() require('gitsigns').preview_hunk() end, { desc = 'Preview hunk' })
vim.keymap.set('n', '<leader>hb', function() require('gitsigns').blame_line({ full = true }) end, { desc = 'Blame line' })
vim.keymap.set('n', '<leader>hB', function() require('gitsigns').toggle_current_line_blame() end, { desc = 'Toggle line blame' })

vim.keymap.set('n', '<leader>jj', '<cmd>CMakeBuild<cr>', { desc = 'CMake build' })

vim.keymap.set('n', '<leader>rst', '<cmd>CMakeSelectLaunchTarget<cr>', { desc = 'CMake select run target' })
vim.keymap.set('n', '<leader>rsb', '<cmd>CMakeSelectBuildTarget<cr>', { desc = 'CMake select build target' })
vim.keymap.set('n', '<leader>rsp', '<cmd>CMakeSelectBuildPreset<cr>', { desc = 'CMake select preset' })

vim.keymap.set('n', '<leader>fg', function() require('telescope.builtin').live_grep() end, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fw', function() require('telescope.builtin').grep_string() end, { desc = 'Live grep word under cursor' })

if vim.env.TERM_PROGRAM == 'ghostty' then
  vim.keymap.set('n', '<C-j>', '<C-w>h', { noremap = true, silent = false })
  vim.keymap.set('n', '<C-k>', '<C-w>j', { noremap = true, silent = true })
  vim.keymap.set('n', '<C-l>', '<C-w>k', { noremap = true, silent = false })
  vim.keymap.set('n', '<C-;>', '<C-w>l', { noremap = true, silent = true })
else
  vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_left)
  vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_down)
  vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_up)
  vim.keymap.set('n', '<C-;>', require('smart-splits').move_cursor_right)

  vim.keymap.set('n', '<A-j>', require('smart-splits').resize_left)
  vim.keymap.set('n', '<A-k>', require('smart-splits').resize_down)
  vim.keymap.set('n', '<A-l>', require('smart-splits').resize_up)
  vim.keymap.set('n', '<A-;>', require('smart-splits').resize_right)
end
-- vim.keymap.set('n', '<A-;>', require('smart-splits').resize_right)
