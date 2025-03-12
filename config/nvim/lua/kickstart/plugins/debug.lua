-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    return {
      -- Basic debugging keymaps, feel free to change to your liking!
      { '<leader>ds', dap.continue, desc = 'Debug: Start/Continue' },
      { '<leader>si', dap.step_into, desc = 'Debug: Step Into' },
      { '<leader>sn', dap.step_over, desc = 'Debug: Step Over' },
      { '<leader>so', dap.step_out, desc = 'Debug: Step Out' },
      { '<leader>b', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
      {
        '<leader>B',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
      },
      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      { '<F7>', dapui.toggle, desc = 'Debug: See last session result.' },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }
    local function set_debug_keymaps()
      vim.api.nvim_set_keymap('n', '<F5>', "<Cmd>lua require'dap'.continue()<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<F10>', "<Cmd>lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<F11>', "<Cmd>lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<F12>', "<Cmd>lua require'dap'.step_out()<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<Leader>db', "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<Leader>dr', "<Cmd>lua require'dap'.repl.open()<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<Leader>so', "<Cmd>lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
    end

    -- Function to remove debug keymaps
    local function remove_debug_keymaps()
      vim.api.nvim_del_keymap('n', '<F5>')
      vim.api.nvim_del_keymap('n', '<F10>')
      vim.api.nvim_del_keymap('n', '<F11>')
      vim.api.nvim_del_keymap('n', '<F12>')
      vim.api.nvim_del_keymap('n', '<Leader>db>')
      vim.api.nvim_del_keymap('n', '<Leader>dr>')
    end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
    dap.listeners.after.event_initialized['dap_keymaps'] = function()
      set_debug_keymaps()
    end

    -- Unregister keymaps when debugging session ends
    dap.listeners.after.event_terminated['dap_keymaps'] = function()
      remove_debug_keymaps()
    end

    dap.listeners.after.event_exited['dap_keymaps'] = function()
      remove_debug_keymaps()
    end
  end,
}
