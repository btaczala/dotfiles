local function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local Path = require('plenary.path')
require("cmake").setup({
	parameters_file = "neovim.json",
    build_dir = Path:new('{cwd}', 'build-macos', ''),
    default_projects_path = Path:new(vim.loop.os_homedir(), 'Projects'),
    configure_args = { '-D', 'CMAKE_EXPORT_COMPILE_COMMANDS=1', '-G', 'Ninja Multi-Config', '-D', 'CMAKE_CXX_COMPILER_LAUNCHER=ccache','-D','CMAKE_C_COMPILER_LAUNCHER=ccache'},
	build_args = {},
	dap_configuration = { type = "lldb", request = "launch" },
	dap_open_command = require("dapui").open,
})

require("telescope").load_extension("cmake")

function format()
	if vim.bo.filetype == "qml" then
		print(string.format("qmlformat -i '%s'", vim.fn.expand("%p")))
		local file = io.popen(string.format("qmlformat -i '%s'", vim.fn.expand("%")))
		local output = file:read("*all")
		file:close()
		vim.cmd(":e %")
	elseif vim.bo.filetype == "cmake" then
		print(string.format("cmake-format -i '%s'", vim.fn.expand("%p")))
		local file = io.popen(string.format("cmake-format -i '%s'", vim.fn.expand("%")))
		local output = file:read("*all")
		file:close()
		vim.cmd(":e %")
	else
		print("lsp format")
		vim.cmd(":lua vim.lsp.buf.formatting()")
	end
end
