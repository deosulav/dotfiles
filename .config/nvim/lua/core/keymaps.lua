vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- keymaps for copy paste with system
vim.keymap.set('v', '<C-c>', '"+y')
vim.keymap.set('n', '<C-v>', '"+p')
vim.keymap.set('i', '<C-v>', '<C-r>+')

