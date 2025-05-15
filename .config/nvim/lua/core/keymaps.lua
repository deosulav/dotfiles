vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>') -- Clear highlight
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- keymaps for copy paste with system
vim.keymap.set('v', '<C-c>', '"+y')
vim.keymap.set('n', '<C-v>', '"+p')
vim.keymap.set('i', '<C-v>', '<C-r>+')
