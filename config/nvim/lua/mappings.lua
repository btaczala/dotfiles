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
map("n", "<Leader>q", ":lua require('bufdelete').bufdelete(0, true)<CR>")
map("n", "<Leader>g", ":Git<CR>")
map("n", "<Leader>a", ":CMake build_all<CR>")
map("n", "<Leader>rr", ":CMake build_and_run<CR>")
map("n", "<Leader>rd", ":CMake build_and_debug<CR>")
map("n", "<leader>cp", ":let @+ = expand(\"%\")<CR>")
map("n", "<leader>CP", ":let @+ = expand(\"%:p\")<CR>")

-- debugging
map("n", "<leader>do", ":lua require(\"dapui\").toggle()<CR>")
map("n", "<leader>dx", ":lua require(\"dapui\").close()<CR>")
map("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>")
map("n", "<leader>dc", ":lua require'dap'.continue()<CR>")
map("n", "<leader>dq", ":lua require'dap'.run_to_cursor()<CR>")

-- terminal
map("n", "<leader>tt", ":ToggleTerm<CR>")

function _G.set_terminal_keymaps()
  local opts = {noremap = true}
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

map("n", "<leader>cf", ":lua format()<CR>")
