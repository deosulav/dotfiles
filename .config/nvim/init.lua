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

  vim.keymap.set("n", "gr", function() vscode.action("editor.action.referenceSearch.trigger") end)

  vim.keymap.set("n", "]d", function() vscode.action("editor.action.marker.nextInFiles") end)
  vim.keymap.set("n", "[d", function() vscode.action("editor.action.marker.prevInFiles") end)

  vim.keymap.set("n", "]c", function() vscode.action("workbench.action.editor.nextChange") end)
  vim.keymap.set("n", "[c", function() vscode.action("workbench.action.editor.previousChange") end)

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

  local function smart_move(vscode_cmd, key)
    return function()
      if vim.v.count == 0 and vim.fn.reg_executing() == '' then
        vscode.call(vscode_cmd)
      else
        return key
      end
    end
  end

  vim.keymap.set('n', 'j',      smart_move('cursorDown', 'j'), { expr = true })
  vim.keymap.set('n', '<Down>', smart_move('cursorDown', 'j'), { expr = true })
  vim.keymap.set('n', 'k',      smart_move('cursorUp', 'k'),   { expr = true })
  vim.keymap.set('n', '<Up>',   smart_move('cursorUp', 'k'),   { expr = true })

   -- Visual mode (v, V, <C-v>): extend the selection
  vim.keymap.set('x', 'j',      smart_move('cursorDownSelect', 'j'), { expr = true })
  vim.keymap.set('x', '<Down>', smart_move('cursorDownSelect', 'j'), { expr = true })
  vim.keymap.set('x', 'k',      smart_move('cursorUpSelect', 'k'),   { expr = true })
  vim.keymap.set('x', '<Up>',   smart_move('cursorUpSelect', 'k'),   { expr = true })
end






vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
