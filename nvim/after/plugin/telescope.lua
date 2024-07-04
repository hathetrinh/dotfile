require("telescope").setup({
	defaults = {
		file_ignore_patterns = { "node_modules", ".git" },
	},
	pickers = {
		find_files = {
			theme = "dropdown",
		},
		git_files = {
			theme = "dropdown",
		},
		live_grep = {
			theme = "dropdown",
		},
	},
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- case_mode = "ignore_case" -- or "ignore_case" or "respect_case"
		},
	},
})
require("telescope").load_extension("luasnip")
require("telescope").load_extension("dap")
require("telescope").load_extension("git_worktree")
require("telescope").load_extension("fzf")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<cr>", {})
vim.keymap.set("n", "<leader>ft", ":Telescope live_grep<cr>", {})
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<cr>", {})
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<cr>", {})
vim.keymap.set("n", "<leader>fg", ":Telescope git_files<cr>", {})
vim.keymap.set("n", "<leader>fm", ":Telescope marks<cr>", {})
vim.keymap.set("n", "<leader>fr", ":Telescope registers<cr>", {})
vim.keymap.set("n", "<leader>fo", ":Telescope oldfiles<cr>", {})
vim.keymap.set("n", "<leader>fk", ":Telescope keymaps<cr>", {})
vim.keymap.set("n", "<leader>f/", ":Telescope luasnip<cr>", {})
vim.keymap.set("n", "<leader>fc", ":Telescope git_commits<cr>", {})
vim.keymap.set("n", "<leader>fx", ":Telescope git_status<cr>", {})
vim.keymap.set("n", "<leader>lb", ":Telescope dap list_breakpoints<cr>", {})
vim.keymap.set("n", "<leader>fw", ":Telescope git_worktree git_worktrees<cr>", {})
vim.keymap.set("n", "<leader>fs", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
