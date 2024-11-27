--require("java").setup()
local lsp_zero = require("lsp-zero")

--configuration lsp server
require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {
		"tsserver",
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
		"jdtls",
	},
	handlers = {
		-- this first function is the "default handler"
		-- it applies to every language server without a "custom handler"
		function(server_name)
			require("lspconfig")[server_name].setup({})
		end,

		-- this is the "custom handler" for `jdtls`
		-- noop is an empty function that doesn't do anything
		jdtls = lsp_zero.noop,
	},
})

local lspconfig = require("lspconfig")

lspconfig.jdtls.setup({
	settings = {
		java = {
			configuration = {
				runtimes = {
					{
						name = "JavaSE-17",
						path = "/Users/ttha/Development/cde/java17/",
						default = true,
					},
				},
			},
		},
	},
})

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

lspconfig.tsserver.setup({
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

lsp_zero.preset("recommended")

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

lsp_zero.set_sign_icons({
	error = "✘",
	warn = "▲",
	hint = "⚑",
	info = "»",
})

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

--lsp_zero.setup()

lsp_zero.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = true }
	lsp_zero.default_keymaps({ buffer = bufnr })

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
end)
