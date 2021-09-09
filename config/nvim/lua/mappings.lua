local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- mappings
map("n", "<Leader>f", ":FzfLua live_grep<CR>")
map("n", "<Leader>h", ":FzfLua command_history<CR>")
map("n", "<C-P>", ":FzfLua files<CR>")
map("n", "<Leader>b", ":FzfLua buffers<CR>")
map("n", "<Leader>q", ":lua require('bufdelete').bufdelete(0, true)<CR>")
map("n", "<Leader>g", ":Git<CR>")
map("n", "<Leader>a", ":Dispatch<CR>")

vim.api.nvim_set_keymap("v", "<leader>cc", "<Plug>kommentary_visual_default<C-c>", {})
vim.api.nvim_set_keymap("n", "<leader>cic", "<Plug>kommentary_line_increase", {})
vim.api.nvim_set_keymap("n", "<leader>cc", "<Plug>kommentary_line_default", {})
