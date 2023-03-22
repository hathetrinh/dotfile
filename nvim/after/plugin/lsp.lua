local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
    "tsserver",
    "eslint",
    "html",
    "cssls",
    "lua_ls",
    "cssmodules_ls",
    "rust_analyzer",
    "sqlls",
    "tailwindcss",
    "emmet_ls",
})

-- Fix Undefined global 'vim'
lsp.configure("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
})

lsp.configure("emmet_ls", {
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
local cmp_mappings = lsp.defaults.cmp_mappings({
    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

-- disable completion with tab
-- this helps with copilot setup
cmp_mappings["<Tab>"] = nil
cmp_mappings["<S-Tab>"] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings,
})

lsp.configure("tsserver", {
    flags = {
        debounce_text_changes = 150,
    },
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = "E",
        warn = "W",
        hint = "H",
        info = "I",
    },
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    --if client.name == "eslint" then
    --vim.cmd.LspStop("eslint")
    --return
    --end

    if client.name == "volar" or client.name == "tsserver" then
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentFormattingRangeProvider = false
    end

    if client.name == "cssmodules_ls" then
        client.server_capabilities.definitionProvider = false
    end

    if client.name == "cssls" then
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
    end

    vim.keymap.set("n", "gd", ":Telescope lsp_definitions<CR>", opts)
    vim.keymap.set("n", "gr", ":Telescope lsp_references<CR>", opts)
    vim.keymap.set("n", "gi", ":Telescope lsp_implementations<CR>", opts)
    vim.keymap.set("n", "<leader>la", ":Telescope lsp_code_actions<CR>",opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>lw", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "<leader>x", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>X", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end)

local null_ls = require("null-ls")

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
    debug = false,
    sources = {
        formatting.prettier.with({ extra_args = { "--single-quote", "--jsx-single-quote" } }),
        formatting.black.with({ extra_args = { "--fast" } }),
        formatting.stylua,
        formatting.sql_formatter,
        diagnostics.flake8,
    },
})
lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
})
