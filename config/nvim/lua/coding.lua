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

local Path = require("plenary.path")
require("tasks").setup({
	default_params = { -- Default module parameters with which `neovim.json` will be created.
		cmake = {
			cmd = "/usr/local/bin/cmake", -- CMake executable to use, can be changed using `:Task set_module_param cmake cmd`.
			build_dir = tostring(Path:new("{cwd}", "build")),
			build_type = "Debug", -- Build type, can be changed using `:Task set_module_param cmake build_type`.
			dap_name = "lldb", -- DAP configuration name from `require('dap').configurations`. If there is no such configuration, a new one with this name as `type` will be created.
			args = { -- Task default arguments.
				configure = { },
			},
		},
	},
	save_before_run = true, -- If true, all files will be saved before executing a task.
	params_file = "neovim.json", -- JSON file to store module and task parameters.
	quickfix = {
		pos = "botright", -- Default quickfix position.
		height = 12, -- Default height.
	},
	dap_open_command = function()
		return require("dap").repl.open()
	end, -- Command to run after starting DAP session. You can set it to `false` if you don't want to open anything or `require('dapui').open` if you are using https://github.com/rcarriga/nvim-dap-ui
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
		local file = io.popen(string.format("cmake-format --line-width 120 -i '%s'", vim.fn.expand("%")))
		local output = file:read("*all")
		file:close()
		vim.cmd(":e %")
	else
		print("lsp format")
		vim.cmd(":lua vim.lsp.buf.format()")
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
