-- Server configs live in lsp/<name>.lua at the config root.

vim.filetype.add({
    filename = {
        ['justfile'] = 'just',
        ['Justfile'] = 'just',
        ['.justfile'] = 'just',
    },
    pattern = {
        ['.*%.justfile'] = 'just',
        ['.*%.yaml'] = {
            priority = -math.huge,
            function(_, bufnr)
                local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ''
                if first_line:match('^esphome:') then
                    return 'yaml.esphome'
                end
            end,
        },
    },
})

vim.lsp.enable({
    'lua_ls',
    'cmake',
    'clangd',
    'qmlls',
    'just',
    'ty',
    'esphome_lsp',
    'jsonls',
})
