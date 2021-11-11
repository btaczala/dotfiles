local function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function COpenOnFailure()
	if vim.g.asyncrun_status == "failure" then
		require("notify")("Compilation failed", "error", { timeout = 3000 })
	else
		require("notify")("OK", "info", { timeout = 1000 })
	end
end

require("cmake").setup({
	parameters_file = "neovim.json",
	build_dir = "{cwd}/build-macos",
	default_projects_path = "~/Projects",
	configure_arguments = '-D CMAKE_EXPORT_COMPILE_COMMANDS=1 -G"Ninja Multi-Config" -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DCMAKE_C_COMPILER_LAUNCHER=ccache',
	build_arguments = "",
	asyncrun_options = { save = 2, post = ":lua COpenOnFailure()" },
	target_asyncrun_options = {}, -- AsyncRun options that will be passed on target execution. See https://github.com/skywind3000/asyncrun.vim#manual
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
