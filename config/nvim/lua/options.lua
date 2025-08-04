vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

vim.o.timeoutlen = 100
vim.o.splitright = true
vim.o.splitbelow = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- folds
-- vim.opt.foldmethod='expr'
-- vim.opt.foldexpr='nvim_treesitter#foldexpr()'
-- vim.opt.foldnestmax = 4
-- vim.opt.foldlevel = 99
-- vim.opt.foldlevelstart = 1


vim.o.spelllang = 'en_us'
vim.o.spellfile = os.getenv 'HOME' .. '/dotfiles/config/nvim/spell/en.utf-8.add'
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10

vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

vim.opt.backupdir = os.getenv('HOME') .. '/.neovim/backup'
vim.diagnostic.config({ virtual_lines = true })

vim.opt.conceallevel = 1
