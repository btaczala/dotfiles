return {
  'stevearc/overseer.nvim',
  opts = {},

  config = function()
    local overseer = require 'overseer'
    overseer.register_template {
      name = 'evstylepreview',
      builder = function()
        return {
          cmd = { 'just', 'evpreview', vim.fn.expand '%:p' },
        }
      end,
    }
    overseer.setup()
  end,
}
