require("core.common")
require("core.keymaps")
require("config.lazy")
require("config.lazyplugins")

-- require('vscode').load('dark') 
vim.cmd.colorscheme('noctis_minimus')


vim.opt.shell = '/bin/zsh'
vim.opt.shellcmdflag = '-ic'

-- Normal mode mapping: <leader>!
-- Prompts for a shell command, inserts output at cursor
vim.keymap.set("n", "<leader>!", function()
  local cmd = vim.fn.input("Shell command: ")
  if cmd ~= "" then
    -- local output = vim.fn.system(cmd)
    local output = vim.fn.system({ vim.o.shell, vim.o.shellcmdflag, cmd })
    -- Remove trailing newline if present
    output = output:gsub("\n$", "")
    vim.api.nvim_put({ output }, "c", true, true)
  end
end, { desc = "Insert shell command output at cursor" })





if vim.g.vscode then
    local vscode = require('vscode')

    vim.api.nvim_set_keymap('n', 'j', 'gj', { noremap = false, silent = true })
    vim.api.nvim_set_keymap('n', 'k', 'gk', { noremap = false, silent = true })

    -- Fold / Unfold current block
    vim.keymap.set('n', 'za', function() vscode.call('editor.toggleFold') end, { desc = 'Toggle fold' })
    vim.keymap.set('n', 'zc', function() vscode.call('editor.fold') end, { desc = 'Close fold' })
    vim.keymap.set('n', 'zo', function() vscode.call('editor.unfold') end, { desc = 'Open fold' })

    -- Fold / Unfold recursively
    vim.keymap.set('n', 'zC', function() vscode.call('editor.foldRecursively') end, { desc = 'Close fold recursively' })
    vim.keymap.set('n', 'zO', function() vscode.call('editor.unfoldRecursively') end, { desc = 'Open fold recursively' })

    -- Global fold management
    vim.keymap.set('n', 'zM', function() vscode.call('editor.foldAll') end, { desc = 'Fold all' })
    vim.keymap.set('n', 'zR', function() vscode.call('editor.unfoldAll') end, { desc = 'Unfold all' })

    -- Fold specific types
    vim.keymap.set('n', 'zB', function() vscode.call('editor.foldAllBlockComments') end, { desc = 'Fold block comments' })

  -- -- Better up and down
  -- Fix folds were automatically opening when navigating with j, k
  vim.keymap.set("n", "j", function()
    if vim.v.count == 0 then
      vscode.call("cursorDown")
    else
      return "j"
    end
  end, { expr = true })

  vim.keymap.set("n", "<Down>", function()
    if vim.v.count == 0 then
      vscode.call("cursorDown")
    else
      return "j"
    end
  end, { expr = true })

  vim.keymap.set("n", "k", function()
    if vim.v.count == 0 then
      vscode.call("cursorUp")
    else
      return "k"
    end
  end, { expr = true })

  vim.keymap.set("n", "<Up>", function()
    if vim.v.count == 0 then
      vscode.call("cursorUp")
    else
      return "k"
    end
  end, { expr = true })
end




vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
