return {
  'salkin-mada/openscad.nvim',
  config = function()
    vim.g.openscad_load_snippets = false
    require 'openscad'
  end,
}
