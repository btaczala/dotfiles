require('blink.cmp').setup({
    keymap = { preset = 'super-tab', ['<CR>'] = { 'accept', 'fallback' } },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    fuzzy = { implementation = 'prefer_rust' },
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = '/Users/bartek/Projects/inmusic/mount_windows/*',
    callback = function() vim.opt_local.backupcopy = 'yes' end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '/Users/bartek/Projects/inmusic/mount_windows/*',
    callback = function() vim.opt.fsync = false end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = '/Users/bartek/Projects/inmusic/mount_windows/*',
    callback = function() vim.opt.fsync = true end,
})

vim.api.nvim_create_autocmd('FileChangedShell', {
    pattern = '/Users/bartek/Projects/inmusic/mount_windows/*',
    callback = function() vim.v.fcs_choice = '' end,
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
require('clangd_extensions').setup({})
require('render-markdown').setup({})

require('auto-dark-mode').setup({
    set_dark_mode = function()
        vim.cmd.colorscheme('tokyonight-night')
    end,
    set_light_mode = function()
        vim.cmd.colorscheme('tokyonight-day')
    end,
})

vim.filetype.add({
    filename = {
        ['justfile'] = 'just',
        ['Justfile'] = 'just',
        ['.justfile'] = 'just',
    },
    pattern = {
        ['.*%.justfile'] = 'just',
    },
})
