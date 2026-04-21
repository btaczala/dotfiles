-- Function to wrap visual selection with #ifdef and #endif
local function wrap_with_ifdef()
  -- Get the visual selection range
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"

  local start_line = start_pos[2]
  local end_line = end_pos[2]

  -- Prompt user for the condition name
  local condition = vim.fn.input 'Enter #ifdef condition: '

  -- If user cancels or enters nothing, abort
  if condition == '' then
    print '\nOperation cancelled'
    return
  end

  -- Get the current buffer
  local bufnr = vim.api.nvim_get_current_buf()

  -- Insert #endif after the selection (do this first to preserve line numbers)
  vim.api.nvim_buf_set_lines(bufnr, end_line, end_line, false, { '#endif // ' .. condition })

  -- Insert #ifdef before the selection
  vim.api.nvim_buf_set_lines(bufnr, start_line - 1, start_line - 1, false, { '#ifdef ' .. condition })

  print('\nWrapped with #ifdef ' .. condition)
end

-- Create a command to call the function
vim.api.nvim_create_user_command('WrapIfdef', wrap_with_ifdef, { range = true })

-- Optional: Create a visual mode mapping
-- Uncomment the line below if you want <leader>if to trigger it in visual mode
-- vim.keymap.set('v', '<leader>if', ':WrapIfdef<CR>', { noremap = true, silent = true })

print 'ifdef_wrapper.lua loaded! Use :WrapIfdef in visual mode or map it to a key'

return {
  wrap_with_ifdef = wrap_with_ifdef,
}
