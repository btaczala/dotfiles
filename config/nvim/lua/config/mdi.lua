-- Local mdi.nvim plugin (~/Projects/mdi.nvim): mdi: icon completion via an
-- in-process LSP plus image previews. The webfont lives in the qt-hass repo.
vim.opt.runtimepath:append('/Users/bartek/Projects/mdi.nvim')

require('mdi').setup({
  font = '/Users/bartek/Projects/qt-hass/fonts/materialdesignicons-webfont.ttf',
})
