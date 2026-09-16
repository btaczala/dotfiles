return {
    cmd = { 'node', vim.fn.expand('~/.local/share/esphome-vscode/server/out/server.js'), '--stdio' },
    filetypes = { 'yaml.esphome' },
    root_markers = { '.esphome', 'secrets.yaml', '.git' },
    settings = {
        esphome = {
            validator = 'local',
            pythonPath = vim.fn.expand('~/.pyenv/versions/esphome/bin/python'),
        },
    },
}
