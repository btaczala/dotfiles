vim.g.mapleader = ' '

vim.keymap.set('n', 'ff', function() require('telescope.builtin').find_files() end, { desc = 'Find files' })
vim.keymap.set('n', '<leader><leader>', function() require('telescope.builtin').buffers() end, { desc = 'Telescope buffers' })

vim.keymap.set({'n', 'v'}, 'j', 'h')
vim.keymap.set({'n', 'v'}, 'k', 'j')
vim.keymap.set({'n', 'v'}, 'l', 'k')
vim.keymap.set({'n', 'v'}, ';', 'l')

vim.keymap.set('n', '<leader>ww', '<cmd>write<cr>')


vim.keymap.set('n', '<leader>lf', function() vim.lsp.buf.format() end, { desc = 'LSP format buffer' })
-- nvim 0.12 only sends diagnostics whose range contains the cursor, so fix-its
-- are missed when the cursor is elsewhere on the line. Send the whole line's.
vim.keymap.set({'n', 'v'}, '<leader>la', function()
    if vim.api.nvim_get_mode().mode ~= 'n' then return vim.lsp.buf.code_action() end
    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
    local diagnostics = {}
    for _, d in ipairs(vim.diagnostic.get(0, { lnum = lnum })) do
        if d.user_data and d.user_data.lsp then table.insert(diagnostics, d.user_data.lsp) end
    end
    vim.lsp.buf.code_action({ context = { diagnostics = diagnostics } })
end, { desc = 'LSP code action' })
vim.keymap.set('n', '<leader>lD', function() vim.lsp.buf.definition() end, { desc = 'LSP go to definition' })
vim.keymap.set('n', '<leader>ld', function() vim.lsp.buf.declaration() end, { desc = 'LSP go to declaration' })
vim.keymap.set('n', '<leader>lld', function() vim.cmd('rightbelow vsplit') vim.lsp.buf.definition() end, { desc = 'LSP go to definition in vsplit' })
vim.keymap.set('n', '<leader>llD', function() vim.cmd('rightbelow vsplit') vim.lsp.buf.declaration() end, { desc = 'LSP go to declaration in vsplit' })
vim.keymap.set('n', '<leader>lx', function() vim.lsp.buf.rename() end, { desc = 'LSP rename' })
vim.keymap.set('n', '<leader>ls', function() require('telescope.builtin').lsp_document_symbols() end, { desc = 'LSP document symbols' })
vim.keymap.set('n', '<leader>li', function() require('telescope.builtin').lsp_incoming_calls() end, { desc = 'LSP incoming calls' })
vim.keymap.set('n', '<leader>lo', function() require('telescope.builtin').lsp_outgoing_calls() end, { desc = 'LSP outgoing calls' })
vim.keymap.set('n', '<leader>lh', '<cmd>ClangdSwitchSourceHeader<cr>', { desc = 'Clangd switch header/source' })

vim.keymap.set('n', '<leader>cp', function()
    local git_root = vim.fn.systemlist('git -C ' .. vim.fn.shellescape(vim.fn.expand('%:p:h')) .. ' rev-parse --show-toplevel')[1]
    local full = vim.fn.expand('%:p')
    vim.fn.setreg('+', git_root and full:sub(#git_root + 2) or full)
end, { desc = 'Copy git-relative path to clipboard' })
vim.keymap.set('n', '<leader>cP', function() vim.fn.setreg('+', vim.fn.expand('%:p')) end, { desc = 'Copy full path to clipboard' })

vim.keymap.set('n', '<leader>d', function() vim.diagnostic.open_float() end, { desc = 'Show diagnostics' })
vim.keymap.set('n', '<leader>qq', function() vim.diagnostic.setqflist() end, { desc = 'Diagnostics to quickfix' })

vim.keymap.set('n', '<leader>jj', '<cmd>CMakeBuild<cr>', { desc = 'CMake build' })

vim.keymap.set('n', '<leader>tr', function() require('neotest').run.run() end, { desc = 'Test run nearest' })
vim.keymap.set('n', '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end, { desc = 'Test run file' })
vim.keymap.set('n', '<leader>ts', function() require('neotest').run.stop() end, { desc = 'Test stop' })
vim.keymap.set('n', '<leader>to', function() require('neotest').output_panel.toggle() end, { desc = 'Test output panel' })
vim.keymap.set('n', '<leader>tS', function() require('neotest').summary.toggle() end, { desc = 'Test summary' })
vim.keymap.set('n', ']t', function() require('neotest').jump.next({ status = 'failed' }) end, { desc = 'Next failed test' })
vim.keymap.set('n', '[t', function() require('neotest').jump.prev({ status = 'failed' }) end, { desc = 'Prev failed test' })

vim.keymap.set('n', '<leader>rr', '<cmd>CMakeRun<cr>', { desc = 'CMake run target' })
vim.keymap.set('n', '<leader>rst', '<cmd>CMakeSelectLaunchTarget<cr>', { desc = 'CMake select run target' })
vim.keymap.set('n', '<leader>rsb', '<cmd>CMakeSelectBuildTarget<cr>', { desc = 'CMake select build target' })
vim.keymap.set('n', '<leader>rsp', '<cmd>CMakeSelectBuildPreset<cr>', { desc = 'CMake select preset' })

vim.keymap.set('n', '<leader>gg', function() require('neogit').open() end, { desc = 'Neogit status' })
vim.keymap.set('n', '<leader>gc', function() require('neogit').open({ 'commit' }) end, { desc = 'Neogit commit' })
vim.keymap.set('n', '<leader>gp', function() require('neogit').open({ 'pull' }) end, { desc = 'Neogit pull' })
vim.keymap.set('n', '<leader>gP', function() require('neogit').open({ 'push' }) end, { desc = 'Neogit push' })

vim.keymap.set('n', '<leader>fg', function() require('telescope.builtin').live_grep() end, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fw', function() require('telescope.builtin').grep_string() end, { desc = 'Live grep word under cursor' })
vim.keymap.set('n', '<leader>fW', function()
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  -- capture before the picker steals the cursor
  local word = vim.fn.expand('<cword>')

  require('telescope.pickers').new({}, {
    prompt_title = 'rg file type (<Tab> to pick several)',
    -- lines look like "cpp: *.C, *.H, *.cc, ..."
    finder = require('telescope.finders').new_oneshot_job({ 'rg', '--type-list' }, {
      entry_maker = function(line)
        local name = line:match('^([^:]+):')
        return name and { value = name, display = line, ordinal = line } or nil
      end,
    }),
    sorter = require('telescope.config').values.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local picker = action_state.get_current_picker(prompt_bufnr)
        local selected = picker:get_multi_selection()
        if #selected == 0 then selected = { action_state.get_selected_entry() } end
        actions.close(prompt_bufnr)

        local args = {}
        for _, entry in ipairs(selected) do
          table.insert(args, '--type=' .. entry.value)
        end
        require('telescope.builtin').grep_string({ search = word, additional_args = args })
      end)
      return true
    end,
  }):find()
end, { desc = 'Grep word under cursor (pick rg file type)' })

vim.keymap.set('n', '<leader>fG', function()
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  require('telescope.pickers').new({}, {
    prompt_title = 'rg file type (<Tab> to pick several)',
    -- lines look like "cpp: *.C, *.H, *.cc, ..."
    finder = require('telescope.finders').new_oneshot_job({ 'rg', '--type-list' }, {
      entry_maker = function(line)
        local name = line:match('^([^:]+):')
        return name and { value = name, display = line, ordinal = line } or nil
      end,
    }),
    sorter = require('telescope.config').values.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local picker = action_state.get_current_picker(prompt_bufnr)
        local selected = picker:get_multi_selection()
        if #selected == 0 then selected = { action_state.get_selected_entry() } end
        actions.close(prompt_bufnr)

        local args = {}
        for _, entry in ipairs(selected) do
          table.insert(args, '--type=' .. entry.value)
        end
        require('telescope.builtin').live_grep({ additional_args = args })
      end)
      return true
    end,
  }):find()
end, { desc = 'Live grep (pick rg file type)' })

vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<C-;>', require('smart-splits').move_cursor_right)

vim.keymap.set('n', '<A-j>', require('smart-splits').resize_left)
vim.keymap.set('n', '<A-k>', require('smart-splits').resize_down)
vim.keymap.set('n', '<A-l>', require('smart-splits').resize_up)
vim.keymap.set('n', '<A-;>', require('smart-splits').resize_right)

-- Kitty and Ghostty both swallow Option+l as a keybind (resize_up), so
-- outside Normal mode it composes to ł at the OS level; make that explicit
-- wherever text is being entered instead of leaving it to chance.
vim.keymap.set({ 'i', 'c', 't' }, '<A-l>', 'ł', { noremap = true })
