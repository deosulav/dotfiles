vim.api.nvim_set_keymap('n', '<leader>F', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>',
  { noremap = true, silent = true })
