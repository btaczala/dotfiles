local wk = require("which-key")
local function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

wk.register({
	t = {
		name = "Terminal", -- optional group name
		t = { "<cmd>ToggleTerm<cr>", "Toggle terminal" }, -- create a binding with label
	},
	d = {
		name = "debugging",
		o = { "<cmd>lua require('dapui').toggle()<cr>", "Open debugging UI" },
		x = { "<cmd>lua require('dapui').close()<cr>", "Close debugging UI" },
		b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle breakpoint" },
		c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
		q = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run to cursor" },
	},
	r = {
		name = "compile",
		r = { "<cmd>CMake build_and_run<cr>", "Run program" },
		d = { "<cmd>CMake build_and_debug<cr>", "Debug a program" },
		t = { "<cmd>Telescope cmake select_target<cr>", "Select a target" },
	},
	a = { "<cmd>lua compile()<cr>", "compile" },
}, { prefix = "<leader>" })

-- mappings
map("n", "<Leader>ff", ":Telescope grep_string<CR>")
map("n", "<Leader>fg", ":Telescope live_grep<CR>")
map("n", "<Leader>fh", ":Telescope command_history<CR>")
map("n", "<C-P>", ":Telescope fd<CR>")
map("n", "<Leader>b", ":Telescope buffers<CR>")
map("n", "<Leader>q", ":lua require('bufdelete').bufdelete(0, true)<CR>")
map("n", "<Leader>g", ":Git<CR>")
map("n", "<leader>cp", ':let @+ = expand("%")<CR>')
map("n", "<leader>CP", ':let @+ = expand("%:p")<CR>')

function _G.set_terminal_keymaps()
	local opts = { noremap = true }
	vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
