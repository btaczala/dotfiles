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
map("n", "<Leader>a", ":CMake build_all<CR>")
map("n", "<Leader>r", ":CMake build_and_run<CR>")
map("n", "<leader>cp", ":let @+ = expand(\"%\")<CR>")
map("n", "<leader>CP", ":let @+ = expand(\"%:p\")<CR>")

-- debugging
map("n", "<leader>do", ":lua require(\"dapui\").toggle()<CR>")
map("n", "<leader>dx", ":lua require(\"dapui\").close()<CR>")
map("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>")
map("n", "<leader>dc", ":lua require'dap'.continue()<CR>")
