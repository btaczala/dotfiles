vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.justfile",
  command = "set filetype=just"
})
