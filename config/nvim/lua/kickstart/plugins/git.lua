return {
  {
    'FabijanZulj/blame.nvim',
    lazy = false,
    dependencies = { 'tpope/vim-fugitive' },
    config = function()
      require('blame').setup {}
    end,
  },
}
