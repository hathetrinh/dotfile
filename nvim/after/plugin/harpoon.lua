local mark = require('harpoon.mark')
local ui = require('harpoon.ui')

vim.keymap.set('n', '<leader>b', mark.add_file)
vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu)

