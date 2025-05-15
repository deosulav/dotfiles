require("core.common")
require("core.keymaps")
require("config.lazy")
require("config.lazyplugins")

require('vscode').load('dark')


vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
