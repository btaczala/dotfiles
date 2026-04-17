vim.pack.add({
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/folke/which-key.nvim',
  'https://github.com/saghen/blink.cmp',
  'https://github.com/f-person/auto-dark-mode.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/mrjones2014/smart-splits.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/Civitasv/cmake-tools.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
})
vim.pack.add({ 'https://github.com/dmtrKovalenko/fff.nvim' })

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(event)
    if event.data.updated then
      require('fff.download').download_or_build_binary()
    end
  end,
})
