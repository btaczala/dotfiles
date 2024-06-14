local auto_dark_mode = require('auto-dark-mode')

auto_dark_mode.setup({
	update_interval = 1000,
	set_dark_mode = function()
        vim.opt.background = 'dark'
	end,
	set_light_mode = function()
        vim.opt.background = 'light'
	end,
})
auto_dark_mode.init()

require('onedark').setup {
    style = 'darker',
    transparent = true,
    lualine = {
        transparent = true
    }

}
require('onedark').load()

vim.cmd([[colorscheme onedark]])
