local home = os.getenv("HOME")
local jdtls = require("jdtls")
local jdtls_dap = require("jdtls.dap")
local jdtls_setup = require("jdtls.setup")
local path_to_mason_packages = home .. "/.local/share/nvim/mason/packages"
local path_to_jdtls = path_to_mason_packages .. "/jdtls"
local path_to_jdebug = path_to_mason_packages .. "/java-debug-adapter"
local path_to_jtest = path_to_mason_packages .. "/java-test"
local lombok_path = path_to_jdtls .. "/lombok.jar"
local path_to_jar = path_to_jdtls .. "/plugins/org.eclipse.equinox.launcher__1.7.0.v20250519-0528.jar"
local path_to_config = path_to_jdtls .. "/config_mac"
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local java_home = os.getenv("JAVA_HOME")
local java_bin = java_home .. "/bin/java"
local root_dir = jdtls_setup.find_root(root_markers)
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = home .. "/.cache/jdtls/workspace" .. project_name

local bundles = {
    vim.fn.glob(path_to_jdebug .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true),
}

vim.list_extend(bundles, vim.split(vim.fn.glob(path_to_jtest .. "/extension/server/*.jar", true), "\n"))

local on_attach = function(_, bufnr)
    jdtls.setup_dap({ hotcodereplace = "auto" })
    jdtls_dap.setup_dap_main_class_configs()
    jdtls_setup.add_commands()

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" })

    require("lsp_signature").on_attach({
        bind = true,
        padding = "",
        handler_opts = {
            border = "rounded",
        },
        hint_prefix = "󱄑 ",
    }, bufnr)
end

local capabilities = {
    workspace = {
        configuration = true
    },
    textDocument = {
        completion = {
            completionItem = {
                snippetSupport = true
            }
        }
    }
}

local config = {
    cmd = {
        --path_to_jdtls .. "/bin/jdtls",
        java_bin,
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx1g",
        "-javaagent:" .. lombok_path,
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",

        -- 💀
        "-jar",
        path_to_jar,
        "-configuration",
        path_to_config,
        "-data",
        workspace_dir
    },
    root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),

    settings = {
        ['java.format.settings.url'] = "/Users/cafesuaphin/.config/nvim/styles/googleStyle.xml",
        ['java.format.settings.profile'] = "GoogleStyle",
        java = {
            references = {
                includeDecompiledSources = true,
            },
            format = {
                settings = {
                    --url = "/Users/ttha/Development/Project.xml",
                    url = "/Users/cafesuaphin/.config/nvim/styles/googleStyle.xml",
                    profile = "GoogleStyle"
                },
            },
            eclipse = {
                downloadSources = true,
            },
            maven = {
                downloadSources = true,
            },
            signatureHelp = { enabled = true },
            contentProvider = { preferred = "fernflower" },
            completion = {
                favoriteStaticMembers = {
                    "org.hamcrest.MatcherAssert.assertThat",
                    "org.hamcrest.Matchers.*",
                    "org.hamcrest.CoreMatchers.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                    "org.mockito.Mockito.*",
                },
                filteredTypes = {
                    "com.sun.*",
                    "io.micrometer.shaded.*",
                    "java.awt.*",
                    "jdk.*",
                    "sun.*",
                },
                importOrder = {
                    "java",
                    "javax",
                    "com",
                    "org",
                },
            },
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
            codeGeneration = {
                toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                    -- flags = {
                    -- 	allow_incremental_sync = true,
                    -- },
                },
                useBlocks = true,
            },
            configuration = {

                runtimes = {
                    {
                        name = "JavaSE-25",
                        path = "/Users/cafesuaphin/.jenv/versions/25",
                        default = true,
                    }
                }
            }
        }
    },
}
--config.on_attach = on_attach
--config.capabilities = capabilities

--config.on_init = function(client, _)
--client.notify('workspace/didChangeConfiguration', { settings = config.settings })
--end

--local extendedClientCapabilities = require 'jdtls'.extendedClientCapabilities
--extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

--config.init_options = {
--bundles = bundles,
--extendedClientCapabilities = extendedClientCapabilities,
--}
require('jdtls').start_or_attach(config)


vim.keymap.set("n", "<leader>jio", "<Cmd>lua require'jdtls'.organize_imports()<CR>", { desc = "" })
vim.keymap.set("n", "<leader>dt", "<Cmd>lua require'jdtls'.test_class()<CR>", { desc = "" })
vim.keymap.set("n", "<leader>dn", "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", { desc = "" })
vim.keymap.set("v", "<leader>jev", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", { desc = "" })
vim.keymap.set("n", "<leader>jev", "<Cmd>lua require('jdtls').extract_variable()<CR>", { desc = "" })
vim.keymap.set("v", "<leader>jem", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", { desc = "" })
