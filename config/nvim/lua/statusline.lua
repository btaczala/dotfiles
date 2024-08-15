-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.


local treesitter = require("nvim-treesitter")
local function treelocation()
	current =  treesitter.statusline({
		indicator_size = 90,
		type_patterns = { "class", "function", "method" },
		separator = " -> ",
	}):gsub("\n", " ")
    return current
end

local function lsp()
	local msg = "No Active Lsp"
	local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
	local clients = vim.lsp.get_active_clients()
	if next(clients) == nil then
		return msg
	end
	for _, client in ipairs(clients) do
		local filetypes = client.config.filetypes
		if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
			return "  " .. client.name
		end
	end
	return msg
end

local function diff_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed,
		}
	end
end

require("lualine").setup({
	options = {
		theme = "tokyonight",
		-- theme = "onedark",
		component_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = {
			{ "mode", separator = { left = "" }, right_padding = 2 },
		},
		lualine_b = { { "filename", path = 1, shorting_target = 40 }, { "b:gitsigns_head", icon = "" } },
		lualine_c = { "diagnostics" },
		lualine_x = { lsp, "lsp_progress", "overseer" },
		lualine_y = { },
		lualine_z = {
			{ "location", separator = { right = "" }, left_padding = 2 },
		},
	},
	inactive_sections = {
		lualine_a = { { "filename", path = 1, shorting_target = 40 } },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "location" },
	},
	tabline = {},
	extensions = {
		"toggleterm",
		"quickfix",
		"fugitive",
	},
})
