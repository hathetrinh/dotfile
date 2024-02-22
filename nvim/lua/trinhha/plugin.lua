local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
    -- Packer can manage itself
    use("wbthomason/packer.nvim")

    use({
        "nvim-telescope/telescope.nvim",
        tag = "0.1.0",
        -- or                            , branch = '0.1.x',
        requires = { { "nvim-lua/plenary.nvim" } },
    })

    use({
        "morhetz/gruvbox",
        as = "gruvbox",
        config = function()
            vim.cmd("colorscheme gruvbox")
        end,
    })

    use({
        "tiagovla/tokyodark.nvim",
        opts = {
            -- custom options here
        },
        config = function(_, opts)
            require("tokyodark").setup(opts) -- calling setup is optional
        end,
    })

    -- Using Packer
    use("navarasu/onedark.nvim")

    use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate}" })
    use("nvim-treesitter/playground")
    --use("ThePrimeagen/harpoon")
    use("mbbill/undotree")
    use("tpope/vim-fugitive")

    use({
        "VonHeikemen/lsp-zero.nvim",
        branch = "v1.x",
        requires = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },

            -- Autocompletion
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },

            -- Snippets
            {
                "L3MON4D3/LuaSnip",
                build = vim.fn.has("win32") ~= 0
                    and
                    "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
                    or nil,
                dependencies = {
                    "zeioth/friendly-snippets", -- change to rafamadriz once all is merged
                    "benfowler/telescope-luasnip.nvim",
                },
                config = function(_, opts)
                    if opts then
                        require("luasnip").config.setup(opts)
                    end
                    vim.tbl_map(function(type)
                        require("luasnip.loaders.from_" .. type).lazy_load()
                    end, { "vscode", "snipmate", "lua" })
                    -- friently-snippets - enable standardized comments snippets
                    require("luasnip").filetype_extend("typescript", { "tsdoc" })
                    require("luasnip").filetype_extend("javascript", { "jsdoc" })
                    require("luasnip").filetype_extend("lua", { "luadoc" })
                    require("luasnip").filetype_extend("python", { "python-docstring" })
                    require("luasnip").filetype_extend("rust", { "rustdoc" })
                    require("luasnip").filetype_extend("cs", { "csharpdoc" })
                    require("luasnip").filetype_extend("java", { "javadoc" })
                    require("luasnip").filetype_extend("sh", { "shelldoc" })
                    require("luasnip").filetype_extend("c", { "cdoc" })
                    require("luasnip").filetype_extend("cpp", { "cppdoc" })
                    require("luasnip").filetype_extend("php", { "phpdoc" })
                    require("luasnip").filetype_extend("kotlin", { "kdoc" })
                    require("luasnip").filetype_extend("ruby", { "rdoc" })
                end,
            },
            { "rafamadriz/friendly-snippets" },
            { "benfowler/telescope-luasnip.nvim" },
        },
    })

    use({
        "nvimdev/lspsaga.nvim",
        --opt = true,
        --branch = "main",
        --event = "LspAttach",
        --after = "nvim-lspconfig",
        config = function()
            require("lspsaga").setup({})
        end,
    })

    use("tpope/vim-liquid")

    use("jose-elias-alvarez/null-ls.nvim")

    use("folke/zen-mode.nvim")

    use("github/copilot.vim")

    use({
        "nvim-tree/nvim-tree.lua",
        requires = {
            "nvim-tree/nvim-web-devicons", -- optional, for file icons
        },
        tag = "nightly", -- optional, updated every week. (see issue #1193)
    })

    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
    })

    use("tpope/vim-surround")
    use("windwp/nvim-ts-autotag");

    use({
        "lewis6991/gitsigns.nvim",
        -- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
    })

    use({
        "phaazon/hop.nvim",
        branch = "v2", -- optional but strongly recommended
        config = function()
            -- you can configure Hop the way you like here; see :h hop-config
            require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
        end,
    })

    use("preservim/nerdcommenter")

    use({
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    })

    use("lukas-reineke/indent-blankline.nvim")
    --use({
    ---- Add indentation guides even on blank lines
    --"lukas-reineke/indent-blankline.nvim",
    --main = "ibl",
    --opts = {
    --char = "┊",
    --show_trailing_blankline_indent = false,
    --},
    --})

    use({
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        setup = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    })

    use({
        "akinsho/toggleterm.nvim",
        tag = "*",
        config = function()
            require("toggleterm").setup()
        end,
    })

    use("norcalli/nvim-colorizer.lua")

    use("sindrets/diffview.nvim")

    use("tigion/nvim-asciidoc-preview")

    --debug
    use("mfussenegger/nvim-dap")

    use({
        "microsoft/vscode-js-debug",
        opt = true,
        run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
    })

    use("mxsdev/nvim-dap-vscode-js")

    use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })

    use("nvim-telescope/telescope-dap.nvim")

    use("ThePrimeagen/git-worktree.nvim")

    --use("mfussenegger/nvim-jdtls")

    if packer_bootstrap then
        require("packer").sync()
    end
end)
