-- configs lsp server
require("mason").setup({
	registries = {
		"github:nvim-java/mason-registry",
		"github:mason-org/mason-registry",
	},
})

require("mason-lspconfig").setup({
	ensure_installed = {
		"ts_ls",
		"eslint",
		"html",
		"cssls",
		"lua_ls",
		"cssmodules_ls",
		"rust_analyzer",
		"sqlls",
		"tailwindcss",
		"jsonls",
		"emmet_ls",
	},
	handlers = {
		-- this first function is the "default handler"
		-- it applies to every language server without a "custom handler"
		function(server_name)
			require("lspconfig")[server_name].setup({})
		end,

		-- this is the "custom handler" for `jdtls`
		-- noop is an empty function that doesn't do anything
		--jdtls = lsp_zero.noop,
	},
})

-- setups java
require("java").setup()

local lspconfig = require("lspconfig")

lspconfig.jdtls.setup({})

lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = {
					"vim",
					"require",
				},
			},
		},
	},
})

lspconfig.ts_ls.setup({
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentFormattingRangeProvider = false
	end,
})

lspconfig.volar.setup({
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentFormattingRangeProvider = false
	end,
})

lspconfig.cssmodules_ls.setup({
	on_init = function(client)
		client.server_capabilities.definitionProvider = false
	end,
})

lspconfig.cssls.setup({
	on_init = function(client)
		client.server_capabilities.definitionProvider = false
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
	end,
})

lspconfig.emmet_ls.setup({
	filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
	init_options = {
		html = {
			options = {
				-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
				["bem.enabled"] = true,
			},
		},
	},
})

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
	sources = cmp.config.sources({
		{ name = "path" },
		{ name = "nvim_lsp" },
		{ name = "codeium" },
		{ name = "luasnip", option = { show_autosnippets = true } },
		{ name = "buffer" },
	}),
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
		["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		-- Scroll up and down in the completion documentation
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
})

vim.opt.signcolumn = "yes"

-- Add borders to floating windows
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

require("lsp_signature").setup({
	bind = true, -- This is mandatory, otherwise border config won't get registered.
	handler_opts = {
		border = "single",
	},
	shadow_guibg = "Green",
	shadow_blend = 36,
	transparency = 30,
})

vim.diagnostic.config({
	signs = true,
	virtual_text = true,
})

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		local opts = { buffer = event.buf }

		vim.keymap.set("n", "gd", ":Lspsaga goto_definition<CR>", opts)
		vim.keymap.set("n", "gr", ":Lspsaga finder<CR>", opts)
		vim.keymap.set("n", "gp", ":Lspsaga peek_definition<CR>", opts)
		vim.keymap.set("n", "gi", ":Telescope lsp_implementations<CR>", opts)
		vim.keymap.set("n", "gt", ":Telescope lsp_type_definitions<CR>", opts)
		vim.keymap.set("n", "<leader>la", ":Lspsaga code_action<CR>", opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<C-k>", ":Lspsaga hover_doc<cr>", opts)
		vim.keymap.set("n", "<leader>lw", vim.lsp.buf.workspace_symbol, opts)
		vim.keymap.set("n", "<leader>ld", ":Telescope diagnostics<CR>", opts)
		vim.keymap.set("n", "<leader>x", vim.diagnostic.goto_next, opts)
		vim.keymap.set("n", "<leader>X", vim.diagnostic.goto_prev, opts)
		vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>ln", ":Lspsaga rename<CR>", opts)
		vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
	end,
})
