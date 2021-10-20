local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function COpenOnFailure()
 if vim.g.asyncrun_status == "failure" then
   vim.cmd('copen')
  end
end

require('cmake').setup({
  parameters_file = 'neovim.json',
  build_dir = '{cwd}/build-macos',
  default_projects_path = '~/Projects',
  configure_arguments = '-D CMAKE_EXPORT_COMPILE_COMMANDS=1 -G"Ninja Multi-Config" -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DCMAKE_C_COMPILER_LAUNCHER=ccache',
  build_arguments = '',
  asyncrun_options = { save = 2, post = ":lua COpenOnFailure()" },
  target_asyncrun_options = {}, -- AsyncRun options that will be passed on target execution. See https://github.com/skywind3000/asyncrun.vim#manual
  dap_configuration = { type = 'lldb', request = 'launch' },
  dap_open_command = require('dapui').open,
})

require('telescope').load_extension('cmake')

