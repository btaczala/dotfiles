local dn = require('dark_notify')
-- theme change on MacOS
dn.run(
{
	onchange = function(mode)
        if mode == "dark" then
            vim.g.neon_style = "dark"
        else
            vim.g.neon_style = "light"
        end
	end
})
dn.update()

vim.g.neon_transparent = true
vim.cmd[[colorscheme neon]]
