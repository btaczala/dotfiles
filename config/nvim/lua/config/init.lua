require('config.options')
require('config.pack')
require('config.keymaps')
require('config.diagnostics')
require('config.autocmds')
require('config.lsp')

require('smart-splits').setup()

vim.api.nvim_create_autocmd('User', {
  pattern = 'KittyScrollbackLaunch',
  once = true,
  callback = function() require('kitty-scrollback').setup() end,
})

require('gitsigns').setup({
    attach_to_untracked = true,
    on_attach = function(bufnr)
        local path = vim.api.nvim_buf_get_name(bufnr)
        if path:find('/Users/bartek/Projects/chamsys/mount_windows/mediamaster', 1, true) then
            return false
        end
    end,
})

