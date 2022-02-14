local Path = require("plenary.path")
local opt = vim.opt -- to set options

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local Path = require("plenary.path")
require("cmake").setup({
	parameters_file = "neovim.json",
	build_dir = tostring(Path:new("{cwd}", "build")),
	default_projects_path = tostring(Path:new(vim.loop.os_homedir(), "Projects")),
	configure_args = {
		"-D",
		"CMAKE_EXPORT_COMPILE_COMMANDS=1",
		"-G",
		"Ninja Multi-Config",
		"-D",
		"CMAKE_CXX_COMPILER_LAUNCHER=ccache",
		"-D",
		"CMAKE_C_COMPILER_LAUNCHER=ccache",
	},
	build_args = {},
	dap_configuration = { type = "lldb", request = "launch" },
	dap_open_command = require("dapui").open,
})

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

local function GetFileName(url)
	return url:match("^.+/(.+)$")
end

local function GetFileExtension(url)
	return url:match("^.+(%..+)$")
end

local function file_exists(name)
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

function compile()
	local cwd = Path.new(vim.fn.getcwd())
	if Path.exists(cwd.joinpath("/justfile")) then
		opt.makeprg = "just build"
		vim.cmd(":Dispatch")
	end
end
