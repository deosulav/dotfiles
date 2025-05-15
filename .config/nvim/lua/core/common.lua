vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.number = true
vim.o.relativenumber = true
vim.g.have_nerd_font = true
vim.o.showmode = true
vim.o.mouse = 'a'
vim.o.breakindent = true
vim.o.undofile = true -- Undo history

-- Case insensitive searching
vim.o.ignorecase = true
vim.o.smartcase = true

vim.wo.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300 -- Mapped sequence wait time
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split'           -- Preview substitutions live, as you type!
vim.opt.cursorline = true
vim.o.completeopt = 'menuone,noselect' -- Set completeopt to have a better completion experience
vim.o.termguicolors = true
vim.o.hlsearch = true                  -- Set highlight on search


vim.opt.backspace  = { "indent", "eol", "start" }
vim.opt.showcmd    = true
vim.opt.laststatus = 2
vim.opt.autoread   = true

-- use spaces for tabs
vim.opt.tabstop    = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab  = true
