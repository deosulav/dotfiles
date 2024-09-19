require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "ts_ls", "lua_ls", "rust_analyzer", "emmet_ls" },
}

local on_attach = function(_, _)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})
  vim.keymap.set('', '<leader>D', require('telescope.builtin').lsp_type_definitions, {desc ='[T]ype [D]efinition'})
  vim.keymap.set('n', '<leader>K', vim.lsp.buf.hover, {})
end

require("mason-lspconfig").setup_handlers({
  function(server_name)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local capabilities2 = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true
    require("lspconfig")[server_name].setup({
      capabilities = capabilities2,
      on_attach = on_attach
    })
  end,
})

require'lspconfig'.lua_ls.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
}

require('lspconfig').ts_ls.setup({
  -- on_attach = function(client, bufnr)
  --   -- Disable tsserver's formatting since we use Prettier
  --   client.server_capabilities.document_formatting = false
  -- end,
  settings = {
    jsx = true,
    typescript = true,
  },
})

vim.api.nvim_set_keymap('n', '<leader>F', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', { noremap = true, silent = true })

require('telescope').setup {
  pickers = {
    buffers = {
      sort_lastused = true,
      ignore_current_buffer = true,
      mappings = {
        i = {
          ["<C-d>"] = "delete_buffer",  -- Optional: to delete buffer with <C-d>
        ["<C-h>"] = "which_key"
        }
      },
    },
  },
}


require("neo-tree")
vim.keymap.set('n', '<leader>e', ":Neotree source=filesystem toggle reveal<CR>" , {noremap = true, silent = true})
vim.keymap.set('n', '<leader>g', ":Neotree source=git_status toggle<CR>" , {noremap = true, silent = true})

vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    if vim.fn.winnr('$') == 1 and vim.bo.filetype == 'neo-tree' then
      vim.cmd('q')  -- Close Neotree if it's the last window
    end
  end,
})

