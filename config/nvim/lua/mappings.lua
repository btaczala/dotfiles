local wk = require("which-key")
local function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function file_exists(name)
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

function compile()
	local cwd = vim.fn.getcwd()
	local CMakeFile = cwd .. "/CMakeLists.txt"
	if file_exists(CMakeFile) then
		vim.cmd(":Task start cmake build")
		return
	end
	vim.cmd("Make")
end

local function buf_set_keymap(...)
	vim.api.nvim_buf_set_keymap(0, ...)
end

function lsp_keybindings()
	local opts = { noremap = true, silent = true }
	buf_set_keymap("n", "<leader>li", "<cmd>lua require'telescope.builtin'.diagnostics()<CR>", opts)
	buf_set_keymap("n", "<leader>ld", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "<leader>lD", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "<leader>lx", "<cmd>lua require'telescope.builtin'.lsp_references()<CR>", opts)
	buf_set_keymap("n", "<leader>lq", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	buf_set_keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
	buf_set_keymap("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", opts)
	buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
	buf_set_keymap("n", "<leader>lh", "<cmd>ClangdSwitchSourceHeader<CR>", opts)
	buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
	buf_set_keymap("n", "<leader>xx", "<cmd>TroubleToggle<CR>", opts)
	buf_set_keymap("n", "<leader>xw", "<cmd>TroubleToggle lsp_workspace_diagnostics<CR>", opts)
end

wk.register({
	t = {
		name = "Terminal", -- optional group name
		t = { "<cmd>ToggleTerm<cr>", "Toggle terminal" }, -- create a binding with label
	},
	d = {
		name = "debugging",
		o = { "<cmd>lua require('dapui').toggle()<cr>", "Open debugging UI" },
		x = {
			function()
				require("dapui").close()
				require("dap").terminate()
			end,
			"Terminate",
		},
		b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle breakpoint" },
		c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
		q = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run to cursor" },
		n = { "<cmd>lua require'dap'.step_over()<cr>", "Next line" },
		i = { "<cmd>lua require'dap'.step_into()<cr>", "Step in" },
		f = { "<cmd>lua require'dap'.step_out()<cr>", "Step out" },
	},
	r = {
		name = "compile",
		r = { "<cmd>Task start cmake run<cr>", "Run program" },
		d = { "<cmd>Task start cmake debug<cr>", "Debug a program" },
		t = { "<cmd>Telescope cmake select_target<cr>", "Select a target" },
	},
	g = {
		name = "git",
		p = { "<cmd>Git pull<cr>", "Pull from remote" },
		g = { "<cmd>Git<cr>", "Show Git" },
	},
	z = {
		name = "git",
		z = { "<cmd>ZenMode<cr>", "ZenMode" },
	},
	-- a = { "<cmd>Make<cr>", "Compile current target" },
	a = {
		a = { "<cmd>lua compile()<cr>", "Compile current target" },
		c = { "<cmd>Task start cmake configure<cr>", "Show Git" },
		b = { "<cmd>Task start cmake build_all<cr>", "Compile all" },
	},
	A = {},
}, { prefix = "<leader>" })

-- mappings
map("n", "<Leader>ff", ":Telescope grep_string<CR>")
map("n", "<Leader>fg", ':lua require("telescope").extensions.live_grep_args.live_grep_args()<CR>')
map("n", "<Leader>fh", ":Telescope command_history<CR>")
map("n", "<C-P>", ":Telescope fd<CR>")
map("n", "<Leader>b", ":Telescope buffers<CR>")
map("n", "<Leader>q", ":bdelete<CR>")
map("n", "<Leader>g", ":Git<CR>")
map("n", "<Leader>dd", ":Gitsigns toggle_linehl<CR>")
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

vim.cmd("autocmd FileType qml lua WhichKeyQml()")
function WhichKeyQml()
	wk.register({
		r = {
			p = { "<cmd>Dispatch qmlscene %<cr>", "Run qml preview" },
		},
	}, { prefix = "<leader>" })
end
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
