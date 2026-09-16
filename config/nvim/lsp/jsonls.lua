return {
    cmd = { 'vscode-json-language-server', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    root_markers = { '.git' },
    init_options = {
        provideFormatter = false,
    },
    settings = {
        json = {
            validate = { enable = true },
        },
    },
}
