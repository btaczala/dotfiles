local dap = require('dap')
local dapui = require('dapui')

-- Adapter: lldb-dap ships with LLVM (brew install llvm / dnf install lldb).
-- Absolute path required: with runInTerminal (cmake-tools default) lldb-dap
-- re-executes itself via argv[0], which termopen resolves against the
-- project cwd if it's a bare name.
dap.adapters.lldb = {
  type = 'executable',
  command = vim.fn.exepath('lldb-dap'),
  name = 'lldb',
}

dap.configurations.cpp = {
  {
    name = 'Launch executable',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = function()
      return vim.split(vim.fn.input('Args: '), ' +', { trimempty = true })
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
  {
    name = 'Attach to process',
    type = 'lldb',
    request = 'attach',
    pid = function() return require('dap.utils').pick_process() end,
    cwd = '${workspaceFolder}',
  },
}
dap.configurations.c = dap.configurations.cpp

dapui.setup()
require('nvim-dap-virtual-text').setup({})

-- Open/close the UI with the session.
dap.listeners.after.event_initialized['dapui'] = function() dapui.open() end
dap.listeners.before.event_terminated['dapui'] = function() dapui.close() end
dap.listeners.before.event_exited['dapui'] = function() dapui.close() end

vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError' })
vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticError' })
vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticWarn', linehl = 'CursorLine' })

vim.keymap.set('n', '<F5>', function() dap.continue() end, { desc = 'Debug continue/start' })
vim.keymap.set('n', '<F10>', function() dap.step_over() end, { desc = 'Debug step over' })
vim.keymap.set('n', '<F11>', function() dap.step_into() end, { desc = 'Debug step into' })
vim.keymap.set('n', '<F12>', function() dap.step_out() end, { desc = 'Debug step out' })

-- Start debugging: continue an active session; otherwise build & debug the
-- CMake launch target. cmake.debug only exists when cmake-tools' setup ran
-- with nvim-dap available, so fall back to plain dap.continue() otherwise.
vim.keymap.set('n', '<leader>bs', function()
  if dap.session() then
    dap.continue()
    return
  end
  local cmake = require('cmake-tools')
  if cmake.is_cmake_project() and cmake.debug then
    cmake.debug({ fargs = {} })
  else
    dap.continue()
  end
end, { desc = 'Debug start (CMake) / continue' })
vim.keymap.set('n', '<leader>bn', function() dap.step_over() end, { desc = 'Debug step over (next)' })
vim.keymap.set('n', '<leader>bi', function() dap.step_into() end, { desc = 'Debug step into' })
vim.keymap.set('n', '<leader>bo', function() dap.step_out() end, { desc = 'Debug step out' })

vim.keymap.set('n', '<leader>bb', function() dap.toggle_breakpoint() end, { desc = 'Toggle breakpoint' })
vim.keymap.set('n', '<leader>bc', function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = 'Conditional breakpoint' })
vim.keymap.set('n', '<leader>bx', function() dap.clear_breakpoints() end, { desc = 'Clear all breakpoints' })
vim.keymap.set('n', '<leader>bq', function() dap.terminate() end, { desc = 'Debug terminate' })
vim.keymap.set('n', '<leader>bC', function() dap.run_to_cursor() end, { desc = 'Debug run to cursor' })
vim.keymap.set('n', '<leader>bu', function() dapui.toggle() end, { desc = 'Toggle debug UI' })
vim.keymap.set({ 'n', 'v' }, '<leader>be', function() dapui.eval() end, { desc = 'Debug eval expression' })
vim.keymap.set('n', '<leader>br', function() dap.repl.toggle() end, { desc = 'Debug REPL' })

vim.keymap.set('n', '<leader>td', function()
  require('neotest').run.run({ strategy = 'dap' })
end, { desc = 'Test debug nearest' })
