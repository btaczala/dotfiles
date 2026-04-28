vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', '.git' },
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file('', true),
            },
            telemetry = {
                enable = false,
            },
        },
    },
})

vim.lsp.enable('lua_ls')

vim.lsp.config('cmake', {
    cmd = { 'cmake-language-server' },
    filetypes = { 'cmake' },
    root_markers = { 'CMakePresets.json', 'CMakeLists.txt', '.git' },
})

vim.lsp.enable('cmake')

vim.lsp.config('clangd', {
    cmd = { 'clangd', '--background-index', '--clang-tidy', '--log=error', '--header-insertion=never' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
    root_markers = { 'compile_commands.json', 'compile_flags.txt', 'CMakeLists.txt', '.git' },
})

vim.lsp.enable('clangd')


vim.lsp.config('qmlls', {
    cmd = { 'qmlls' },
    filetypes = { 'qml' },
    root_markers = { 'CMakeLists.txt', '.git' },
    on_error = function(code, err)
        if type(err) == 'string' and err:find('table index is nil') then return end
        vim.notify(('qmlls error %d: %s'):format(code, err), vim.log.levels.ERROR)
    end,
})

vim.lsp.enable('qmlls')

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

vim.lsp.config('just', {
    cmd = { 'just-lsp' },
    filetypes = { 'just' },
    root_markers = { 'justfile', 'Justfile', '.git' },
})

vim.lsp.enable('just')

vim.lsp.config('ty', {
    cmd = { 'ty', 'server' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', '.git' },
})

vim.lsp.enable('ty')
