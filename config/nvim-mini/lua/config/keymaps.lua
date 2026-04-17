vim.g.mapleader = ' '

vim.keymap.set('n', 'ff', function() require('fff').find_files() end, { desc = 'FFFind files' })
vim.keymap.set('n', '<leader><leader>', function() require('fff').find_files() end, { desc = 'FFFind files' })

vim.keymap.set({'n', 'v'}, 'j', 'h')
vim.keymap.set({'n', 'v'}, 'k', 'j')
vim.keymap.set({'n', 'v'}, 'l', 'k')
vim.keymap.set({'n', 'v'}, ';', 'l')

vim.keymap.set('n', '<leader>ww', '<cmd>write<cr>')


vim.keymap.set('n', '<leader>lf', function() vim.lsp.buf.format() end, { desc = 'LSP format buffer' })
vim.keymap.set('n', '<leader>ld', function() vim.lsp.buf.definition() end, { desc = 'LSP go to definition' })
vim.keymap.set('n', '<leader>lx', function() vim.lsp.buf.rename() end, { desc = 'LSP rename' })
vim.keymap.set('n', '<leader>lD', function() vim.lsp.buf.declaration() end, { desc = 'LSP go to declaration' })
vim.keymap.set('n', '<leader>ls', function() require('telescope.builtin').lsp_document_symbols() end, { desc = 'LSP document symbols' })
vim.keymap.set('n', '<leader>lh', function()
    vim.lsp.buf.execute_command({ command = 'clangd.switchSourceHeader', arguments = { vim.uri_from_bufnr(0) } })
end, { desc = 'Clangd switch header/source' })

vim.keymap.set('n', '<leader>d', function() vim.diagnostic.open_float() end, { desc = 'Show diagnostics' })

vim.keymap.set('n', '<leader>jj', '<cmd>CMakeBuild<cr>', { desc = 'CMake build' })

vim.keymap.set('n', '<leader>rst', '<cmd>CMakeSelectLaunchTarget<cr>', { desc = 'CMake select run target' })
vim.keymap.set('n', '<leader>rsb', '<cmd>CMakeSelectBuildTarget<cr>', { desc = 'CMake select build target' })
vim.keymap.set('n', '<leader>rsp', '<cmd>CMakeSelectBuildPreset<cr>', { desc = 'CMake select preset' })

vim.keymap.set('n', '<leader>fg', function() require('fff').live_grep() end, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fw', function() require('fff').live_grep({ query = vim.fn.expand('<cword>') }) end, { desc = 'Live grep word under cursor' })

vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<C-;>', require('smart-splits').move_cursor_right)
