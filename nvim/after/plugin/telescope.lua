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
})
require("telescope").load_extension("luasnip")
require("telescope").load_extension("dap")
require("telescope").load_extension("git_worktree")
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>ft", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fg", builtin.git_files, {})
vim.keymap.set("n", "<leader>fm", builtin.marks, {})
vim.keymap.set("n", "<leader>fr", builtin.registers, {})
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {})
vim.keymap.set("n", "<leader>fk", builtin.keymaps, {})
vim.keymap.set("n", "<leader>fc", builtin.git_commits, {})
vim.keymap.set("n", "<leader>fx", builtin.git_status, {})
vim.keymap.set("n", "<leader>lb", ":Telescope dap list_breakpoints<cr>", {})
vim.keymap.set("n", "<leader>fw", ":Telescope git_worktree git_worktrees<cr>", {})
vim.keymap.set("n", "<leader>fs", function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
