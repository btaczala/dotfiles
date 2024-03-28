local lspconfig = require("lspconfig")
local lsp_status = require("lsp-status")

require("mappings")

local on_attach = function(client, bufnr)
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	require("lsp-inlayhints").on_attach(client, bufnr)
	-- Mappings.
	lsp_keybindings()
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.offsetEncoding = "utf-8"
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.qmlformat.with({
			filetypes = { "qml", "qmljs" },
		}),
		null_ls.builtins.formatting.fixjson,
		null_ls.builtins.formatting.autopep8,
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.formatting.just,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.code_actions.shellcheck,
	},
	on_attach = on_attach,
})

require("clangd_extensions").setup({
	server = {
		on_attach = on_attach,
	},
})
local servers = { "cmake", "tsserver", "html" }
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

if vim.fn.has("mac") then
	lspconfig["clangd"].setup({
		cmd = { "clangd", "--query-driver=/Library/Developer/CommandLineTools/usr/bin/c++,/Library/Developer/CommandLineTools/usr/bin/clang++,/Users/bartek/.espressif/tools/xtensa-esp32s3-elf/esp-12.2.0_20230208/xtensa-esp32s3-elf/bin/xtensa-esp32s3-elf-g++", "--log=verbose" },
		-- cmd = { "clangd", "--log=verbose" },
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

-- lspconfig.

-- Set qml files to be qmljs
-- vim.cmd([[ autocmd BufNewFile,BufRead *.qml set filetype=qml]])
-- Don't enable qmlls just yet - it consumes a lot of CPU
-- lspconfiPUBLICg.qmlls.setup({})
lspconfig.pylsp.setup({
	on_attach = on_attach,
	settings = {
		pylsp = {
			plugins = {
				autopep8 = {
					enabled = false,
				},
				pycodestyle = {
					ignore = { "E501" },
					maxLineLength = 120,
				},
				yapf = {
					enabled = true,
				},
				mccabe = {
					threshold = 20,
				},
			},
		},
	},
})

lsp_status.register_progress()

vim.o.completeopt = "menuone,noselect"

local luasnip = require("luasnip")
local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- nvim-cmp setup
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	formatting = {
		format = function(entry, vim_item)
			-- fancy icons and a name of kind
			vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
			-- set a name for each source
			vim_item.menu = ({
				buffer = "[Buffer]",
				nvim_lsp = "[LSP]",
				ultisnips = "[UltiSnips]",
				luasnip = "[LuaSnip]",
				nvim_lua = "[Lua]",
				cmp_tabnine = "[TabNine]",
				look = "[Look]",
				path = "[Path]",
				spell = "[Spell]",
				calc = "[Calc]",
				emoji = "[Emoji]",
			})[entry.source.name]
			return vim_item
		end,
	},
	mapping = {
		["<C-l>"] = cmp.mapping.select_prev_item(),
		["<C-k>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{
			name = "buffer",
			option = {
				get_bufnrs = function()
					return vim.api.nvim_list_bufs()
				end,
			},
		},
	},
})

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local events = require("luasnip.util.events")
