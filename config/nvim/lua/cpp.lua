local ts = vim.treesitter
local ts_utils = require 'nvim-treesitter.ts_utils'

local function add_function_implementation()
  -- Get the current buffer and cursor position
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1] - 1, cursor[2]

  -- Get the parser and parse the buffer
  local parser = ts.get_parser(bufnr, 'cpp')
  local tree = parser:parse()[1]
  local root = tree:root()

  -- Tree-sitter query to match function declarations
  local query = [[
    (function_definition
      declarator: (function_declarator
        declarator: (identifier) @name
        parameters: (parameter_list) @params
      )
    ) @function
  ]]

  local parsed_query = vim.treesitter.query.parse('cpp', query)

  -- Find the function declaration at the cursor position
  local function_node = nil
  for _, match, _ in parsed_query:iter_matches(root, bufnr) do
    local node = match[2]
    if node then
      local start_row, start_col = node:start()
      local end_row, end_col = node:end_()
      if start_row <= row and row <= end_row and start_col <= col and col <= end_col then
        function_node = node
        break
      end
    else
      print('Node is nil for match:', vim.inspect(match))
    end
    -- if start_row <= row and row <= end_row and start_col <= col and col <= end_col then
    --   function_node = node
    --   break
    -- end
  end

  if not function_node then
    print 'No function declaration found at the cursor position.'
    return
  end

  -- Extract function name and parameters
  local name_node = function_node:named_child(1)
  local params_node = function_node:named_child(2)
  local function_name = ts_utils.get_node_text(name_node, bufnr)
  local params_text = ts_utils.get_node_text(params_node, bufnr)

  -- Generate the function implementation
  local implementation = string.format('\n%s %s {\n  // TODO: Implement function\n}\n', function_name, params_text)

  -- Insert the function implementation below the current line
  vim.api.nvim_buf_set_lines(bufnr, row + 1, row + 1, false, vim.split(implementation, '\n'))
end

-- Create a Neovim command for easy execution
vim.api.nvim_create_user_command('AddFunctionImplementation', add_function_implementation, {})
