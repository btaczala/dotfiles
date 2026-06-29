require('config.options')
require('config.pack')
require('config.keymaps')
require('config.diagnostics')
require('config.autocmds')
require('config.lsp')

require('smart-splits').setup({
  multiplexer_integration = 'kitty',
})

require('tint').setup({
  tint = -60,
  saturation = 0.6,
  window_ignore_function = function(winid)
    -- don't dim floating windows (telescope, which-key, claude-code, etc.)
    return vim.api.nvim_win_get_config(winid).relative ~= ''
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'KittyScrollbackLaunch',
  once = true,
  callback = function() require('kitty-scrollback').setup() end,
})

require('neotest').setup({
  adapters = {
    require('neotest-ctest'),
  },
})

require('neogit').setup({
  -- Match the global jkl; motion layout inside Neogit's status buffer.
  -- (Neogit binds status + popup mappings buffer-locally, overriding the
  -- global j->h / k->j / l->k / ;->l remaps from keymaps.lua.)
  mappings = {
    status = {
      ['j'] = false,        -- was MoveDown; fall through to global j (left)
      ['k'] = 'MoveDown',   -- jkl; layout: down
      ['l'] = 'MoveUp',     -- jkl; layout: up
    },
    popup = {
      ['l'] = false,        -- free l (now "up"); relocate the log popup
      ['gl'] = 'LogPopup',
    },
  },
})

require('claude-code').setup({
  window = {
    position = 'botright vsplit',
    split_ratio = 0.35,
  },
  keymaps = {
    toggle = {
      variants = {
        continue = '<leader>cc',
        resume = '<leader>cr',
        verbose = '<leader>cV',
      },
    },
    window_navigation = false,
    scrolling = true,
  },
})

vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*claude*',
  callback = function(ev)
    local opts = { noremap = true, silent = true, buffer = ev.buf }
    vim.keymap.set('t', '<C-y>', [[<C-\><C-n>]], opts)
    if vim.env.TERM_PROGRAM == 'ghostty' then
      vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>h]], opts)
      vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>j]], opts)
      vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>k]], opts)
      vim.keymap.set('t', '<C-;>', [[<C-\><C-n><C-w>l]], opts)
    else
      local ss = require('smart-splits')
      vim.keymap.set('t', '<C-j>', function() vim.cmd('stopinsert') ss.move_cursor_left() end, opts)
      vim.keymap.set('t', '<C-k>', function() vim.cmd('stopinsert') ss.move_cursor_down() end, opts)
      vim.keymap.set('t', '<C-l>', function() vim.cmd('stopinsert') ss.move_cursor_up() end, opts)
      vim.keymap.set('t', '<C-;>', function() vim.cmd('stopinsert') ss.move_cursor_right() end, opts)
      vim.keymap.set('t', '<A-j>', function() ss.resize_left() end, opts)
      vim.keymap.set('t', '<A-k>', function() ss.resize_down() end, opts)
      vim.keymap.set('t', '<A-l>', function() ss.resize_up() end, opts)
      vim.keymap.set('t', '<A-;>', function() ss.resize_right() end, opts)
    end
  end,
})


