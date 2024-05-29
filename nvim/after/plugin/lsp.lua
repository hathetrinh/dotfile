local lsp_zero = require("lsp-zero")

--local lua_opts = lsp_zero.nvim_lua_ls()
local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = {
					"vim",
					"require",
				},
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})
--require("lspconfig").lua_ls.setup(lua_opts)

lsp_zero.preset("recommended")

-- Fix Undefined global 'vim'
lsp_zero.configure("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

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

lsp_zero.configure("emmet_ls", {
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
local cmp_action = require("lsp-zero").cmp_action()

cmp.setup({
	sources = {
		{ name = "path" },
		{ name = "nvim_lsp" },
		{ name = "buffer", keyword_length = 3 },
		{ name = "luasnip", keyword_length = 2 },
	},
	mapping = cmp.mapping.preset.insert({
		-- `Enter` key to confirm completion
		["<CR>"] = cmp.mapping.confirm({ select = false }),

		-- Ctrl+Space to trigger completion menu
		["<C-Space>"] = cmp.mapping.complete(),

		-- Navigate between snippet placeholder
		["<C-n>"] = cmp_action.luasnip_jump_forward(),
		["<C-p>"] = cmp_action.luasnip_jump_backward(),

		-- Scroll up and down in the completion documentation
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
	}),
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
})

lsp_zero.configure("tsserver", {
	flags = {
		debounce_text_changes = 150,
	},
})

lsp_zero.set_sign_icons({
	error = "✘",
	warn = "▲",
	hint = "⚑",
	info = "»",
})

require("lspconfig").tsserver.setup({
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentFormattingRangeProvider = false
	end,
})

require("lspconfig").volar.setup({
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentFormattingRangeProvider = false
	end,
})

require("lspconfig").cssmodules_ls.setup({
	on_init = function(client)
		client.server_capabilities.definitionProvider = false
	end,
})

require("lspconfig").cssls.setup({
	on_init = function(client)
		client.server_capabilities.definitionProvider = false
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
	end,
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
