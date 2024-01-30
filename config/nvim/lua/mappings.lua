local wk = require("which-key")
local function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.kitty_navigator_no_mappings = 1

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
		-- vim.cmd(":Task start cmake build")
		vim.cmd(":CMakeBuild")
		return
	end
	vim.cmd("Make")
end

function configure()
	-- vim.cmd(":CMakeGenerate")
	-- vim.cmd(":Task start cmake configure")
	vim.cmd(":CMakeGenerate")
	vim.cmd(":LspRestart")
end

function run_tests()
	-- vim.cmd(":Task start cmake build_all")
	vim.cmd(":CMakeBuild")
	vim.cmd(":Dispatch ctest --test-dir build --output-on-failure --stop-on-failure")
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
	buf_set_keymap("n", "<leader>lp", "<cmd>lua require'goto-preview'.goto_preview_definition()<CR>", opts)
	buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
	buf_set_keymap("n", "<leader>lh", "<cmd>ClangdSwitchSourceHeader<CR>", opts)
	buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
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
		d = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle breakpoint" },
		c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
		q = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run to cursor" },
		n = { "<cmd>lua require'dap'.step_over()<cr>", "Next line" },
		i = { "<cmd>lua require'dap'.step_into()<cr>", "Step in" },
		f = { "<cmd>lua require'dap'.step_out()<cr>", "Step out" },
	},
	r = {
		name = "run",
		r = { "<cmd>CMakeRun<cr>", "Run program" },
		-- r = { "<cmd>Task start cmake run<cr>", "Run program" },
		d = { "<cmd>Task start cmake debug<cr>", "Debug a program" },
		s = { "<cmd>Task set_module_param cmake target<cr>", "Select a target" },
		t = { "<cmd>lua run_tests()<cr>", "Build tests" },
	},
	g = {
		name = "git",
		p = { "<cmd>Git pull<cr>", "Pull from remote" },
		g = { "<cmd>Git<cr>", "Show Git" },
	},
	z = {
		name = "ZenMode",
		z = { "<cmd>ZenMode<cr>", "ZenMode" },
	},
	D = { "<cmd>Dispatch<cr>", "Dispatch" },
	-- a = { "<cmd>Make<cr>", "Compile current target" },
	a = {
		a = { "<cmd>lua compile()<cr>", "Compile current target" },
		c = { "<cmd>lua configure()<cr>", "CMake configure & LspRestart" },
		-- c = { "<cmd>Task start cmake configure<cr>", "Show Git" },
		-- b = { "<cmd>Task start cmake build_all<cr>", "Compile all" },
		b = { "<cmd>CMakeBuild all<cr>", "Compile all" },
	},
	f = {
		f = { "<cmd>Telescope grep_string<CR>", "Telescope grep" },
		g = { '<cmd>lua require("telescope").extensions.live_grep_args.live_grep_args()<CR>', "Telescope live grep" },
	},
	A = {},
	o = {
		o = { "<cmd>OverseerQuickAction open output in quickfix<CR>", "Overseer open quickfix" },
		t = { "<cmd>OverseerToggle<CR>", "Overseer toggle" },
	},
}, { prefix = "<leader>" })

-- mappings
map("n", "<Leader>fh", ":Telescope command_history<CR>")
map("n", "<C-P>", ":Telescope fd<CR>")
map("n", "<Leader>b", ":Telescope buffers<CR>")
map("n", "<Leader>q", ":bdelete<CR>")
map("n", "<Leader>g", ":Git<CR>")
map("n", "<Leader>gd", ":Gitsigns toggle_linehl<CR>")
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

local opts = { noremap = true, silent = true }

local function quickfix()
	vim.lsp.buf.code_action({
		filter = function(a)
			return a.isPreferred
		end,
		apply = true,
	})
end
vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)

vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)

vim.keymap.set("n", "<leader>lQ", quickfix, opts)
