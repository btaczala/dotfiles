return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration

    -- Only one of these is needed.
    'nvim-telescope/telescope.nvim', -- optional
    'ibhagwan/fzf-lua', -- optional
    'echasnovski/mini.pick', -- optional
  },
  config = function()
    local neogit = require 'neogit'
    local diffview = require 'diffview'
    local path = vim.fn.getcwd()
    if string.sub(path, 1, #'/Users/bartek/Projects/inmusic/mount_windows/') == '/Users/bartek/Projects/inmusic/mount_windows/' then
      return
    end
    neogit.setup {
      use_default_keymaps = false,
      mappings = {
        status = {
          ['l'] = 'MoveUp',
          ['k'] = 'MoveDown',
          ['<tab>'] = 'Toggle',
          ['<cr>'] = 'GoToFile',
          ['<leader>s'] = 'Stage',
          ['<leader>R'] = 'RefreshBuffer',
          ['<leader>S'] = 'StageUnstaged',
          ['<leader>u'] = 'Unstage',
          ['<leader>U'] = 'UnstageStaged',
          ['<leader>x'] = 'Discard',
        },
        commit_editor_I = {
          ['<c-c><c-c>'] = 'Submit',
          ['<c-c><c-k>'] = 'Abort',
        },
        rebase_editor_I = {
          ['<c-c><c-c>'] = 'Submit',
          ['<c-c><c-k>'] = 'Abort',
        },
        popup = {
          ['<leader>c'] = 'CommitPopup',
          ['<leader>d'] = 'DiffPopup',
          ['<leader>l'] = 'LogPopup',
          ['<leader>P'] = 'PushPopup',
          ['<leader>p'] = 'PullPopup',
          ['<leader>r'] = 'RebasePopup',
          ['?'] = 'HelpPopup',
          ['<leader>h'] = 'HelpPopup',
        },
      },
    }
    local actions = require 'diffview.actions'
    diffview.setup {
      keymaps = {
        rebase_editor = {
          ['p'] = false,
          ['r'] = false,
          ['e'] = false,
          ['s'] = false,
          ['f'] = false,
          ['x'] = false,
          ['d'] = false,
          ['b'] = false,
          ['q'] = false,
          ['<cr>'] = 'OpenCommit',
          ['gl'] = 'MoveUp',
          ['gk'] = 'MoveDown',
          ['<c-c><c-c>'] = 'Submit',
          ['<c-c><c-k>'] = 'Abort',
          ['[c'] = 'OpenOrScrollUp',
          [']c'] = 'OpenOrScrollDown',
        },
        file_history_panel = {
          { 'n', 'j', actions.close_fold, { desc = 'Collapse fold' } },
          { 'n', 'k', actions.next_entry, { desc = 'Bring the cursor to the next file entry' } },
          { 'n', 'l', actions.prev_entry, { desc = 'Bring the cursor to the previous file entry' } },
          { 'n', ';', actions.select_entry, { desc = 'Open the diff for the selected entry' } },
        },
        file_panel = {
          { 'n', 'k', actions.next_entry, { desc = 'Bring the cursor to the next file entry' } },
          { 'n', '<down>', actions.next_entry, { desc = 'Bring the cursor to the next file entry' } },
          { 'n', 'l', actions.prev_entry, { desc = 'Bring the cursor to the previous file entry' } },
          { 'n', '<up>', actions.prev_entry, { desc = 'Bring the cursor to the previous file entry' } },
          { 'n', '<cr>', actions.select_entry, { desc = 'Open the diff for the selected entry' } },
          { 'n', 'o', actions.select_entry, { desc = 'Open the diff for the selected entry' } },
          { 'n', ';', actions.select_entry, { desc = 'Open the diff for the selected entry' } },
          { 'n', '<2-LeftMouse>', actions.select_entry, { desc = 'Open the diff for the selected entry' } },
          { 'n', 'j', actions.close_fold, { desc = 'Collapse fold' } },
          { 'n', 'zc', actions.close_fold, { desc = 'Collapse fold' } },
        },
      },
    }
    vim.keymap.set('n', '<leader>g', '<cmd>Neogit<cr>', { desc = 'Neo[g]it' })
  end,
}
