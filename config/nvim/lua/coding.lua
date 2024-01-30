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
			cmd = "/opt/homebrew/bin/cmake", -- CMake executable to use, can be changed using `:Task set_module_param cmake cmd`.
			build_dir = tostring(Path:new("{cwd}", "build")),
			build_type = "Debug", -- Build type, can be changed using `:Task set_module_param cmake build_type`.
			dap_name = "lldb", -- DAP configuration name from `require('dap').configurations`. If there is no such configuration, a new one with this name as `type` will be created.
			args = { -- Task default arguments.
				configure = {},
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
		return require("dapui").toggle()
	end, -- Command to run after starting DAP session. You can set it to `false` if you don't want to open anything or `require('dapui').open` if you are using https://github.com/rcarriga/nvim-dap-ui
})

require("cmake-tools").setup({
	cmake_command = "cmake", -- this is used to specify cmake command path
	cmake_regenerate_on_save = false, -- auto generate when save CMakeLists.txt
	cmake_generate_options = {}, -- this will be passed when invoke `CMakeGenerate`
	cmake_build_options = {}, -- this will be passed when invoke `CMakeBuild`
	-- support macro expansion:
	--       ${kit}
	--       ${kitGenerator}
	--       ${variant:xx}
	cmake_build_directory = "build", -- this is used to specify generate directory for cmake, allows macro expansion
	cmake_soft_link_compile_commands = true, -- this will automatically make a soft link from compile commands file to project root dir
	cmake_compile_commands_from_lsp = false, -- this will automatically set compile commands file location using lsp, to use it, please set `cmake_soft_link_compile_commands` to false
	cmake_kits_path = nil, -- this is used to specify global cmake kits path, see CMakeKits for detailed usage
	cmake_variants_message = {
		short = { show = true }, -- whether to show short message
		long = { show = true, max_length = 40 }, -- whether to show long message
	},
	cmake_dap_configuration = { -- debug settings for cmake
		name = "cpp",
		type = "codelldb",
		request = "launch",
		stopOnEntry = false,
		runInTerminal = true,
		console = "integratedTerminal",
	},
	cmake_executor = { -- executor to use
		name = "overseer", -- name of the executor
		opts = {}, -- the options the executor will get, possible values depend on the executor type. See `default_opts` for possible values.
		default_opts = { -- a list of default and possible values for executors
			quickfix = {
				show = "only_on_error", -- "always", "only_on_error"
				position = "belowright", -- "bottom", "top"
				size = 10,
			},
			terminal = {
				name = "CMake terminal",
			}, -- terminal executor uses the values in cmake_terminal
		},
	},
})
require("overseer").setup()

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
