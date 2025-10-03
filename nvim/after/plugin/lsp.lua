-- configs lsp server
require("mason").setup({
    registries = {
        "github:mason-org/mason-registry"
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
        "pyright",
        "pylsp",
        --"volar",
        --"jdtls",
        "vue_ls"
    },
    handlers = {
        -- this first function is the "default handler"
        -- it applies to every language server without a "custom handler"
        function(server_name)
            vim.lsp.enable(server_name)
        end,

        -- this is the "custom handler" for `jdtls`
        -- noop is an empty function that doesn't do anything
        --jdtls = lsp_zero.noop,
    },
})

--local lspconfig = require("lspconfig")

vim.lsp.config('lua_ls', {
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

vim.lsp.enable('pyright')

vim.lsp.enable('pylsp')

local mason_registry = require("mason-registry")
--local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
--.. "/node_modules/@vue/language-server"
local vue_language_server_path = vim.fn.stdpath('data')
    .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'


vim.lsp.config('ts_ls', {
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    init_options = {
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = vue_language_server_path,
                languages = {
                    "javascript",
                    "typescript",
                    "vue",
                },
            },
        },
    },
    settings = {
        typescript = {
            tsserver = {
                useSyntaxServer = false,
            },
            inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
        },
    },
    on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentFormattingRangeProvider = false
    end,
})

vim.lsp.config('volar', {
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    init_options = {
        vue = {
            hybridMode = false,
        },
        typescript = {
            tsdk = "/Users/ttha/Development/cde/node18/lib/node_modules/typescript/bin",
        },
    },
    settings = {
        typescript = {
            inlayHints = {
                enumMemberValues = {
                    enabled = true,
                },
                functionLikeReturnTypes = {
                    enabled = true,
                },
                propertyDeclarationTypes = {
                    enabled = true,
                },
                parameterTypes = {
                    enabled = true,
                    suppressWhenArgumentMatchesName = true,
                },
                variableTypes = {
                    enabled = true,
                },
            },
        },
    },
    on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentFormattingRangeProvider = false
    end,
})

vim.lsp.config('cssmodules_ls', {
    on_init = function(client)
        client.server_capabilities.definitionProvider = false
    end,
})

vim.lsp.config('cssls', {
    on_init = function(client)
        client.server_capabilities.definitionProvider = false
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
    end,
})

vim.lsp.config('emmet_ls', {
    filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "vue" },
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
        vim.keymap.set("n", "<leader>jr", ":JavaRunnerRunMain<CR>", opts)
        vim.keymap.set("n", "<leader>jb", ":JavaBuildBuildWorkspace<CR>", opts)
        vim.keymap.set("n", "<leader>bf", vim.lsp.buf.format, opts)
    end,
})
