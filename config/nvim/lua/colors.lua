local dn = require('dark_notify')
-- theme change on MacOS
dn.run(
{
	onchange = function(mode)
        if mode == "dark" then
            require('github-theme').setup({
                  themeStyle = "dark",
            })
        else
            require('github-theme').setup({
                  themeStyle = "light",
            })
        end
	end
})
dn.update()

vim.g.tokyonight_style = "day"
vim.g.tokyonight_transparent = true

require('lualine').setup {
  options = {
    theme = 'tokyonight'
  },
  sections = {
    lualine_a = {'FugitiveHead', 'diff'},
    lualine_b = {{'filename', path = 1}},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {{'filename', path = 1}},
    lualine_c = {},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
  }
}

require('github-theme').setup({
      themeStyle = "light",
})
