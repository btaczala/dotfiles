-- theme change on MacOS
if vim.fn.has("mac") == 1 then
    local dn = require('dark_notify')
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
end


if vim.fn.has("mac") == 1 then
    local handle = io.popen("$HOME/dotfiles/bin/darkMode")
    local darkMode = handle:read("*a")
    if string.find(darkMode, "Dark") then
        print("Dark mode activated")
        require('github-theme').setup({
              themeStyle = "dark",
              transparent = true
        })
    else
        print("Dark mode is not on?", darkMode)
        require('github-theme').setup({
              themeStyle = "light",
              transparent = true
        })
    end
else
    require('github-theme').setup({
          themeStyle = "light",
          transparent = true
    })
end

require('lualine').setup {
  options = {
    theme = 'github'
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
