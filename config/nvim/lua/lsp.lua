local lspconfig = require('lspconfig')
local lsp_status = require('lsp-status')
local coq = require "coq" -- add this

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', '<leader>ld', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', '<leader>lD', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<leader>lx', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>lf', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.renamecode_action()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
end

local servers = {'cmake', 'clangd'}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup{coq.lsp_ensure_capabilities {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }}
end

lsp_status.register_progress()

-- Some arbitrary servers
require('lualine').setup {
  options = {
    theme = 'neon'
  },
  sections = {lualine_c = {"os.data('%a')", 'data', require'lsp-status'.status}}
}

