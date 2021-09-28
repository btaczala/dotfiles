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

