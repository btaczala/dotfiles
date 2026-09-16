require('blink.cmp').setup({
    keymap = { preset = 'super-tab', ['<CR>'] = { 'accept', 'fallback' } },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    fuzzy = { implementation = 'prefer_rust' },
})

local smb_patterns = {
    '/Users/bartek/Projects/inmusic/mount_windows/*',
    '/Users/bartek/Projects/chamsys/mount_windows/*',
}

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = smb_patterns,
    callback = function() vim.opt_local.backupcopy = 'yes' end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = smb_patterns,
    callback = function() vim.opt.fsync = false end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = smb_patterns,
    callback = function() vim.opt.fsync = true end,
})

vim.api.nvim_create_autocmd('FileChangedShell', {
    pattern = smb_patterns,
    callback = function() vim.v.fcs_choice = '' end,
})

-- Highlight BDD keywords in comments like TODO/FIXME, each in its own color.
-- Scheduled because the built-in Syntax autocmd (registered after user config)
-- clears syntax before sourcing the syntax file, which would wipe a match
-- defined synchronously.
local bdd_keywords = {
    bddGiven = { keyword = 'Given', link = 'DiagnosticInfo' },
    bddWhen = { keyword = 'When', link = 'DiagnosticWarn' },
    bddThen = { keyword = 'Then', link = 'DiagnosticOk' },
}

-- Pill style: the source group's fg becomes the background, with the editor
-- background as text color (falling back to a plain link if colors missing).
local function bdd_link_highlights()
    local normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
    for group, spec in pairs(bdd_keywords) do
        local src = vim.api.nvim_get_hl(0, { name = spec.link, link = false })
        if src.fg and normal.bg then
            vim.api.nvim_set_hl(0, group, { fg = normal.bg, bg = src.fg, bold = true })
        else
            vim.api.nvim_set_hl(0, group, { link = spec.link })
        end
    end
end

vim.api.nvim_create_autocmd('Syntax', {
    group = vim.api.nvim_create_augroup('bdd_keywords', {}),
    callback = function(ev)
        vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(ev.buf) then return end
            vim.api.nvim_buf_call(ev.buf, function()
                for group, spec in pairs(bdd_keywords) do
                    vim.cmd(('syntax match %s /\\<%s:/ contained containedin=.*Comment.*'):format(group, spec.keyword))
                end
            end)
        end)
    end,
})

vim.api.nvim_create_autocmd('ColorScheme', {
    group = 'bdd_keywords',
    callback = bdd_link_highlights,
})
bdd_link_highlights()

vim.api.nvim_create_autocmd('CursorHold', {
    callback = function()
        vim.diagnostic.open_float(nil, { focus = false })
    end,
})

require('which-key').setup()
require('telescope').setup({ extensions = { ['ui-select'] = {} } })
require('telescope').load_extension('ui-select')
require('cmake-tools').setup({
  cmake_dap_configuration = {
    name = 'Launch (CMake target)',
    type = 'lldb',
    request = 'launch',
    stopOnEntry = false,
  },
})
require('clangd_extensions').setup({})
require('render-markdown').setup({})

require('auto-dark-mode').setup({
    set_dark_mode = function()
        vim.cmd.colorscheme('tokyonight-moon')
    end,
    set_light_mode = function()
        vim.cmd.colorscheme('tokyonight-day')
    end,
})

vim.filetype.add({
    filename = {
        ['justfile'] = 'just',
        ['Justfile'] = 'just',
        ['.justfile'] = 'just',
    },
    pattern = {
        ['.*%.justfile'] = 'just',
    },
})
