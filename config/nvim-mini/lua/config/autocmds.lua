require('blink.cmp').setup({
    keymap = { preset = 'super-tab' },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    fuzzy = { implementation = 'prefer_rust' },
})

vim.api.nvim_create_autocmd('CursorHold', {
    callback = function()
        vim.diagnostic.open_float(nil, { focus = false })
    end,
})

require('which-key').setup()
require('telescope').setup({ extensions = { ['ui-select'] = {} } })
require('telescope').load_extension('ui-select')
require('cmake-tools').setup({})

require('auto-dark-mode').setup({
    set_dark_mode = function()
        vim.cmd.colorscheme('tokyonight-night')
    end,
    set_light_mode = function()
        vim.cmd.colorscheme('tokyonight-day')
    end,
})
