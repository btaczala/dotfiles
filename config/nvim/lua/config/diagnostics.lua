local sev = vim.diagnostic.severity

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = { current_line = true },
  severity_sort = true,
  update_in_insert = false,
  float = {
    border = 'rounded',
    source = true,
  },
  signs = {
    text = {
      [sev.ERROR] = 'E',
      [sev.WARN]  = 'W',
      [sev.INFO]  = 'I',
      [sev.HINT]  = 'H',
    },
  },
})
