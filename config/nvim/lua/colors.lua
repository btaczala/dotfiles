-- theme change on MacOS
if vim.fn.has("mac") == 1 then
	local dn = require("dark_notify")
	dn.run()
end

require('onedark').setup {
    style = 'darker',
    transparent = true,
    lualine = {
        transparent = true
    }

}
require('onedark').load()

vim.cmd([[colorscheme onedark]])
