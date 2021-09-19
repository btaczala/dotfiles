-- theme change on MacOS
if vim.fn.has("mac") == 1 then
    local dn = require('dark_notify')
    dn.run(
    {
        onchange = function(mode)
            if mode == "dark" then
                require('github-theme').setup({
                      theme_style = "dark",
                      transparent = true,
                      hide_inactive_statusline = false,
                })
            else
                require('github-theme').setup({
                      theme_style = "light",
                      transparent = true,
                      hide_inactive_statusline = false,
                })
            end
        end
    })
    dn.update()
end

require('lualine').setup {
  options = {
    theme = 'github'
  },
  sections = {
    lualine_a = {'FugitiveHead', 'diff'},
    lualine_b = {{'filename', path = 1}},
    lualine_c = {},
    lualine_x = {'encoding', 'filetype'},
    lualine_y = {},
    lualine_z = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {{'filename', path = 1}},
    lualine_c = {},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
  }
}


if vim.fn.has("mac") == 1 then
    local handle = io.popen("$HOME/dotfiles/bin/darkMode")
    local darkMode = handle:read("*a")
    if string.find(darkMode, "Dark") then
        print("Dark mode activated")
        require('github-theme').setup({
              theme_style = "dark",
              transparent = true,
              hide_inactive_statusline = false,
        })
    else
        print("Dark mode is not on?", darkMode)
        require('github-theme').setup({
              theme_style = "light",
              transparent = true,
              hide_inactive_statusline = false,
        })
    end
else
    require('github-theme').setup({
          theme_style = "light",
    })
end

