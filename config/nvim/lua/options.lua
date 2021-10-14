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
