require('config.options')
require('config.pack')
require('config.keymaps')
require('config.diagnostics')
require('config.autocmds')
require('config.lsp')

require('smart-splits').setup()

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


