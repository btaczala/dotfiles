-- theme change on MacOS
if vim.fn.has("mac") == 1 then
	local dn = require("dark_notify")
	dn.run()
end

vim.g.tokyonight_transparent = true
vim.cmd([[colorscheme tokyonight]])
-- require("onedark").setup({
-- 	style = "darker",
-- 	term_colors = true,
-- 	transparent = true,
-- })
-- require("onedark").load()
