return {
  'mfussenegger/nvim-dap',
  recommended = true,
  desc = 'Debugging support. Requires language specific adapters to be configured. (see lang extras)',

  dependencies = {
    {
      'rcarriga/nvim-dap-ui',
      dependencies = {
        'nvim-neotest/nvim-nio',
      },
      config = function()
        require('dapui').setup()
      end,
    },
    -- virtual text for the debugger
    {
      'theHamsta/nvim-dap-virtual-text',
      opts = {},
    },
  },

  -- stylua: ignore
  keys = {
    { "<leader>d", "", desc = "+debug", mode = {"n", "v"} },
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
    -- { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>df", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>dn", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    { "<leader>dx", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle UI" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
  },

  config = function()
    local namespace = vim.api.nvim_create_namespace 'dap-hlng'
    vim.api.nvim_set_hl(namespace, 'DapBreakpoint', { fg = '#eaeaeb', bg = '#ffffff' })
    vim.api.nvim_set_hl(namespace, 'DapLogPoint', { fg = '#eaeaeb', bg = '#ffffff' })
    vim.api.nvim_set_hl(namespace, 'DapStopped', { fg = '#eaeaeb', bg = '#ffffff' })

    vim.fn.sign_define('DapBreakpoint', { text = '•', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointCondition', { text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })
    local dap = require 'dap'
    local dapui = require 'dapui'

    dap.adapters.codelldb = {
      type = 'server',
      port = '61998',
      executable = {
        -- CHANGE THIS to your path!
        command = '/Users/bartek/.codelldb/extension/adapter/codelldb',
        args = { '--port', '61998' },

        -- On windows you may have to uncomment this:
        -- detached = false,
      },
    }
    dap.defaults.fallback.exception_breakpoints = {'uncaught'}
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.after.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.after.event_exited['dapui_config'] = function()
      dapui.close()
    end
  end,
}
