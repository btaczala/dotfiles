return {
  'frankroeder/parrot.nvim',
  dependencies = { 'ibhagwan/fzf-lua', 'nvim-lua/plenary.nvim' },
  -- optionally include "rcarriga/nvim-notify" for beautiful notifications
  config = function()
    require('parrot').setup {
      -- Providers must be explicitly added to make them available.
      providers = {
        -- provide an empty list to make provider available (no API key required)
        ollama = {},
      },
      chat_shortcut_respond = { modes = { 'n', 'i', 'v', 'x' }, shortcut = '<leader>s' },
    }
  end,
}
