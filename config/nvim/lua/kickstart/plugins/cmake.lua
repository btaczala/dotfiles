return {
  'Civitasv/cmake-tools.nvim',
  dependencies = {
    'neocmakelsp/neocmakelsp',
  },
  config = function()
    local cmake_tools = require 'cmake-tools'
    cmake_tools.setup {
      cmake_use_presets = true,
      cmake_generate_options = { '-DCMAKE_EXPORT_COMPILE_COMMANDS=1' },
      cmake_soft_link_compile_commands = true,
      cmake_kits_path = nil, -- this is used to specify global cmake kits path, see CMakeKits for detailed usage
      cmake_build_directory = "build",
      cmake_regenerate_on_save = false,
      cmake_variants_message = {
        short = { show = true }, -- whether to show short message
        long = { show = true, max_length = 40 }, -- whether to show long message
      },
      cmake_dap_configuration = { -- debug settings for cmake
        name = 'cpp',
        type = 'codelldb',
        request = 'launch',
        stopOnEntry = false,
        runInTerminal = true,
        console = 'integratedTerminal',
      },
      cmake_executor = {
        name = 'quickfix',
        opts = {
          show = 'only_on_error',
        },
      },
      cmake_notifications = {
        runner = { enabled = true },
        executor = { enabled = true },
        spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }, -- icons used for progress display
        refresh_rate_ms = 100, -- how often to iterate icons
      },
      cmake_virtual_text_support = true,
      cmake_runner = {
        name = 'overseer',
      },
    }
  end,
}
