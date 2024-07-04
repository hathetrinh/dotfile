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
		tag = "0.1.6",
		-- or                            , branch = '0.1.x',
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				run = "make",
			},
			{
				"nvim-telescope/telescope-dap.nvim",
			},
		},
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
		branch = "v3.x",
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
				tag = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
				-- install jsregexp (optional!:).
				run = "make install_jsregexp",
				requires = {
					{ "rafamadriz/friendly-snippets" },
				},
			},
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

	use({
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup()
		end,
	})

	use("folke/zen-mode.nvim")

	--use("github/copilot.vim")

	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional, for file icons
		},
		--tag = "nightly", -- optional, updated every week. (see issue #1193)
	})

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	use("tpope/vim-surround")
	use("windwp/nvim-ts-autotag")

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

	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } })

	use("nvim-telescope/telescope-dap.nvim")

	use("ThePrimeagen/git-worktree.nvim")

	--use("mfussenegger/nvim-jdtls")
	use("ray-x/lsp_signature.nvim")

	use({
		"nvim-java/nvim-java",
		tag = "v1.5.1",
		requires = {
			"nvim-java/lua-async-await",
			"nvim-java/nvim-java-refactor",
			"nvim-java/nvim-java-core",
			"nvim-java/nvim-java-test",
			"nvim-java/nvim-java-dap",
			"MunifTanjim/nui.nvim",
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-dap",
			{
				"williamboman/mason.nvim",
				opts = {
					registries = {
						"github:nvim-java/mason-registry",
						"github:mason-org/mason-registry",
					},
				},
			},
		},
	})

	use({
		"eatgrass/maven.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
		},
	})

	--use({
	--"jackMort/ChatGPT.nvim",
	--requires = {
	--"MunifTanjim/nui.nvim",
	--"nvim-lua/plenary.nvim",
	--"nvim-telescope/telescope.nvim",
	--},
	--})

	use({
		"Exafunction/codeium.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
	})

	use({
		"ThePrimeagen/refactoring.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
	})

	use({
		"pmizio/typescript-tools.nvim",
		requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		config = function()
			require("typescript-tools").setup({})
		end,
	})
	if packer_bootstrap then
		require("packer").sync()
	end
end)
