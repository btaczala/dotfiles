local ts = vim.treesitter
local ts_utils = require 'nvim-treesitter.ts_utils'

local function replace_param_with_const_ref()
  local bufnr = vim.api.nvim_get_current_buf()
  local parser = ts.get_parser(bufnr, 'cpp')
  local tree = parser:parse()[1]
  local root = tree:root()

  -- Tree-sitter query to match function parameters
  local query = [[
        (parameter_declaration
            type: (type_identifier) @type
        )
    ]]

  local parsed_query = vim.treesitter.query.parse('cpp', query)
  print(parsed_query)

  -- List of fundamental types that should NOT be modified
  local fundamental_types = {
    ['int'] = true,
    ['float'] = true,
    ['double'] = true,
    ['char'] = true,
    ['bool'] = true,
    ['long'] = true,
    ['short'] = true,
    ['void'] = true,
    ['size_t'] = true,
  }

  -- Iterate over function parameters
  for _, match, _ in parsed_query:iter_matches(root, bufnr) do
    local type_node = match[1]
    local type_text = ts_utils.get_node_text(type_node, bufnr)

    -- Skip fundamental types
    if not fundamental_types[type_text] then
      local new_type = 'const ' .. type_text .. '&'

      -- Replace type in buffer
      vim.api.nvim_buf_set_text(bufnr, type_node:start(), type_node:start_col(), type_node:end_(), type_node:end_col(), { new_type })
    end
  end
end

-- Create a Neovim command for easy execution
vim.api.nvim_create_user_command('ReplaceParamsWithConstRef', replace_param_with_const_ref, {})
