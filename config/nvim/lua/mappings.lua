local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- mappings
map("n", "<Leader>f", ":Telescope live_grep<CR>")
map("n", "<Leader>h", ":Telescope command_history<CR>")
map("n", "<C-P>", ":Telescope find_files<CR>")
map("n", "<Leader>b", ":Telescope buffers<CR>")
map("n", "<Leader>q", ":lua require('bufdelete').bufdelete(0, true)<CR>")
map("n", "<Leader>g", ":Git<CR>")
