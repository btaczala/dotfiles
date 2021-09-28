local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- mappings
map("n", "<Leader>ff", ":Telescope grep_string<CR>")
map("n", "<Leader>fg", ":Telescope live_grep<CR>")
map("n", "<Leader>fh", ":Telescope command_history<CR>")
map("n", "<C-P>", ":Telescope fd<CR>")
map("n", "<Leader>b", ":Telescope buffers<CR>")
map("n", "<Leader>p", ":Telescope git_files<CR>")
map("n", "<Leader>q", ":lua require('bufdelete').bufdelete(0, true)<CR>")
map("n", "<Leader>g", ":Git<CR>")
map("n", "<Leader>a", ":Dispatch<CR>")
map("n", "<leader>cp", ":let @+ = expand(\"%\")<CR>")
map("n", "<leader>CP", ":let @+ = expand(\"%:p\")<CR>")

vim.api.nvim_set_keymap("v", "<leader>cc", "<Plug>kommentary_visual_default<C-c>", {})
vim.api.nvim_set_keymap("n", "<leader>cic", "<Plug>kommentary_line_increase", {})
vim.api.nvim_set_keymap("n", "<leader>cc", "<Plug>kommentary_line_default", {})
