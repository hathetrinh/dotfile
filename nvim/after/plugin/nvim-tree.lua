-- examples for your init.lua

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

local nvimtree = require("nvim-tree.api")
--local tree_cb = nvimtree.nvim_tree_callback

local function my_on_attach(bufnr)
    local api = require("nvim-tree.api")

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("Up"))
    vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
end

-- OR setup with some options
require("nvim-tree").setup({
    on_attach = my_on_attach,
    update_focused_file = {
        enable = true,
        update_cwd = true,
    },
    sort_by = "case_sensitive",
    view = {
        adaptive_size = false,
        width = 50,
        preserve_window_proportions = true,
        --mappings = {
        --list = {
        --{ key = "u", action = "dir_up" },
        --{ key = "h", cb = tree_cb("close_node") },
        --{ key = "v", cb = tree_cb("vsplit") },
        --},
        --},
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
    actions = {
        open_file = {
            resize_window = true,
        },
    },
})
