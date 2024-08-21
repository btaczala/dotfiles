local Path = require("plenary.path")
local opt = vim.opt -- to set options
local dap = require("dap")

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local Path = require("plenary.path")

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
	cmake_runner = { -- runner to use
		name = "terminal", -- name of the runner
		opts = {}, -- the options the runner will get, possible values depend on the runner type. See `default_opts` for possible values.
		default_opts = { -- a list of default and possible values for runners
			quickfix = {
				show = "always", -- "always", "only_on_error"
				position = "belowright", -- "bottom", "top"
				size = 10,
				encoding = "utf-8",
				auto_close_when_success = true, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
			},
			toggleterm = {
				direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
				close_on_exit = false, -- whether close the terminal when exit
				auto_scroll = true, -- whether auto scroll to the bottom
			},
			overseer = {
				new_task_opts = {
					strategy = {
						"toggleterm",
						direction = "horizontal",
						autos_croll = true,
						quit_on_exit = "success",
					},
				}, -- options to pass into the `overseer.new_task` command
				on_new_task = function(task) end, -- a function that gets overseer.Task when it is created, before calling `task:start`
			},
			terminal = {
				name = "Main Terminal",
				prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
				split_direction = "horizontal", -- "horizontal", "vertical"
				split_size = 11,

				-- Window handling
				single_terminal_per_instance = true, -- Single viewport, multiple windows
				single_terminal_per_tab = true, -- Single viewport per tab
				keep_terminal_static_location = true, -- Static location of the viewport if avialable

				-- Running Tasks
				start_insert = false, -- If you want to enter terminal with :startinsert upon using :CMakeRun
				focus = false, -- Focus on terminal when cmake task is launched.
				do_not_add_newline = false, -- Do not hit enter on the command inserted when using :CMakeRun, allowing a chance to review or modify the command before hitting enter.
			},
		},
	},
	cmake_notifications = {
		runner = { enabled = true },
		executor = { enabled = true },
		spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }, -- icons used for progress display
		refresh_rate_ms = 100, -- how often to iterate icons
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
dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = "/Users/bartek/dev/codelldb/extension/adapter/codelldb",
		args = { "--port", "${port}" },
	},
}
