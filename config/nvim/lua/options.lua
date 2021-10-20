local opt = vim.opt -- to set options

-- options
opt.syntax = "enable"
opt.modeline = true
opt.modelines = 1
opt.nu = true
opt.rnu = true
opt.spell = false
opt.spelllang = "en_us,pl"
opt.splitright = true
opt.smartindent = true
opt.encoding = "utf8"
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.exrc = true
opt.signcolumn = "yes"
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.cache/nvim/undodir/"
opt.undofile = true
opt.incsearch = true

opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.foldminlines = 1

vim.o.inccommand = 'nosplit'

--Set highlight on search
vim.o.hlsearch = false

--Make line numbers default
vim.wo.number = true

--Do not save when switching buffers (note: this is now a default on master)
vim.o.hidden = true

--Enable mouse mode
vim.o.mouse = 'a'

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

vim.o.termguicolors = true
