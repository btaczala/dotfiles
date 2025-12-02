---@diagnostic disable: missing-fields
local function switch_header_source_in_split()
  -- Save the current window ID
  local current_window = vim.api.nvim_get_current_win()

  -- Create a new vertical split
  vim.cmd 'vsplit'

  -- Save the ID of the new split window
  local new_window = vim.api.nvim_get_current_win()

  -- Switch back to the original window and run ClangSwitchHeaderSource
  vim.api.nvim_set_current_win(current_window)
  vim.cmd 'ClangdSwitchSourceHeader'
  --
  -- -- Move the corresponding file to the new split
  local new_file = vim.api.nvim_buf_get_name(0)
  vim.api.nvim_set_current_win(new_window)
  vim.cmd('edit ' .. new_file)
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('<leader>lD', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    map('<leader>lx', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    map('<leader>lI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    -- map('<leader>lD', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    map('<leader>ls', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    map('<leader>lw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    map('<leader>ln', vim.lsp.buf.rename, '[R]e[n]ame')

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map('<leader>la', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    map('<leader>ld', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('<leader>lh', '<cmd>ClangdSwitchSourceHeader<CR>', '[G]oto [H]eader')
    map('<leader>lH', switch_header_source_in_split, '[G]oto [H]eader in new split')

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- Servers
local capabilities = require('blink.cmp').get_lsp_capabilities()
vim.lsp.config('neocmake', {
  capabilities = capabilities,
  single_file_support = true, -- suggested
})

vim.lsp.config('neocmake', {})
vim.lsp.config('qmlls', {
  capabilities = capabilities,
  cmd = { '/Users/bartek/Qt/6.10.1/macos/bin/qmllint' },
})
-- vim.lsp.config('ts_ls', { capabilities = capabilities })
-- vim.lsp.config('openscad', { capabilities = capabilities })
vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME .. '/lua',
        },
      },
    })
  end,
  settings = {
    Lua = {
      diagnostics = { globals = 'vim' },
    },
  },
})
-- vim.lsp.config('slint_lsp', { capabilities = capabilities })
-- vim.lsp.config('glsl_analyzer', { capabilities = capabilities })
vim.lsp.config(
  'clangd',
  { capabilities = capabilities, cmd = { '/opt/homebrew/opt/llvm/bin/clangd', '--background-index', '--clang-tidy', '--log=info', '--header-insertion=never' } }
)
vim.lsp.config('pylsp', {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = { 'W391', 'E251' },
          maxLineLength = 120,
        },
      },
    },
  },
})
vim.lsp.enable 'lua_ls'
vim.lsp.enable 'clangd'
vim.lsp.enable 'pylsp'
vim.lsp.enable 'qmlls'
