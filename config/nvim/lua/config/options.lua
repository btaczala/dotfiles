vim.o.termguicolors = true

vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4

vim.o.list = true
vim.o.listchars = 'tab:»·'

vim.o.number = true
vim.o.relativenumber = true

-- Over SSH, yank to the host clipboard via OSC 52 (kitty allows writes by default).
-- Paste returns the last yank instead of querying the terminal, which would make kitty prompt every time.
if vim.env.SSH_TTY then
    local osc52 = require('vim.ui.clipboard.osc52')
    local function paste()
        return { vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('') }
    end
    vim.g.clipboard = {
        name = 'OSC 52',
        copy = { ['+'] = osc52.copy('+'), ['*'] = osc52.copy('*') },
        paste = { ['+'] = paste, ['*'] = paste },
    }
end
