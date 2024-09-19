require("core.common")
require("core.keymaps")
require("config.lazy")
require("config.lazyplugins")
require("core.custom-keymaps")

vim.wo.number = true
vim.wo.relativenumber = true
-- Set highlight on search
vim.o.hlsearch = true
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
