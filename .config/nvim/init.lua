require("core.common")
require("core.keymaps")
require("config.lazy")
require("config.lazyplugins")
require("core.custom-keymaps")

require('vscode').load('dark')
vim.wo.number = true
vim.wo.relativenumber = true

vim.g.have_nerd_font = true

-- Set highlight on search
vim.o.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Enable mouse mode
vim.o.mouse = 'a'

vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.inccommand = 'split'
vim.opt.cursorline = true

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })


vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
