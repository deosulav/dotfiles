require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "ts_ls", "lua_ls", "rust_analyzer", "emmet_ls", "clangd", "gopls", "tailwindcss" },
}

local on_attach = function(_, _)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})
  vim.keymap.set('', '<leader>D', require('telescope.builtin').lsp_type_definitions, { desc = '[T]ype [D]efinition' })
  -- vim.keymap.set('n', '<leader>K', vim.lsp.buf.hover, {})
end

require("mason-lspconfig").setup_handlers({
  function(server_name)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    local capabilities2 = require("cmp_nvim_lsp").default_capabilities(capabilities)
    if server_name == 'ts_ls' then 
      require("lspconfig")[server_name].setup({
        capabilities = capabilities2,
        on_attach = on_attach,
        filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
        settings = {
          jsx = true,
          typescript = true,
        },
      })
    else
      require("lspconfig")[server_name].setup({
        capabilities = capabilities2,
        on_attach = on_attach
      })
    end
  end,
})

require 'lspconfig'.lua_ls.setup {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
}

-- require('lspconfig').ts_ls.setup({
--   -- on_attach = function(client, bufnr)
--   --   -- Disable tsserver's formatting since we use Prettier
--   --   client.server_capabilities.document_formatting = false
--   -- end,
--   filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
--   settings = {
--     jsx = true,
--     typescript = true,
--   },
-- })

vim.api.nvim_set_keymap('n', '<leader>F', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>',
  { noremap = true, silent = true })

require('telescope').setup {
  pickers = {
    buffers = {
      sort_lastused = true,
      ignore_current_buffer = true,
      mappings = {
        i = {
          ["<C-d>"] = "delete_buffer", -- Optional: to delete buffer with <C-d>
          ["<C-h>"] = "which_key"
        }
      },
    },
  },
}


local fzf = require("fzf-lua")

vim.keymap.set('n', '<leader>fsf', ":lua require('fzf-lua').files()<CR>")
vim.keymap.set('n', '<leader>gs', ":lua require('fzf-lua').git_status()<CR>")
vim.keymap.set('n', '<leader>gh', ":lua require('fzf-lua').git_stash()<CR>")
vim.keymap.set('n', '<leader>fc', ":lua require('fzf-lua').changes()<CR>")
vim.keymap.set('n', '<leader>fr', ":lua require('fzf-lua').registers()<CR>")
vim.keymap.set('n', '<leader>fk', ":lua require('fzf-lua').keymaps()<CR>")
vim.keymap.set('n', '<leader>fsh', ":lua require('fzf-lua').search_history()<CR>")
vim.keymap.set('n', '<leader>gd', ":lua require('fzf-lua').lsp_definitions()<CR>")
vim.keymap.set('n', '<leader>gr', ":lua require('fzf-lua').lsp_references()<CR>")
vim.keymap.set('n', '<leader>fca', ":lua require('fzf-lua').lsp_code_actions()<CR>")
vim.keymap.set('n', '<leader>fld', ":lua require('fzf-lua').lsp_workspace_diagnostics()<CR>")
vim.keymap.set('n', '<leader>flf', ":lua require('fzf-lua').lsp_finder()<CR>")
vim.keymap.set('n', '<leader>fr', ":lua require('fzf-lua').resume()<CR>")



require("neo-tree")
vim.keymap.set('n', '<leader>e', ":Neotree source=filesystem toggle reveal<CR>", { noremap = true, silent = true })
-- vim.keymap.set('n', '<leader>g', ":Neotree source=git_status toggle<CR>" , {noremap = true, silent = true})

vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    if vim.fn.winnr('$') == 1 and vim.bo.filetype == 'neo-tree' then
      vim.cmd('q') -- Close Neotree if it's the last window
    end
  end,
})

require("gitsigns").setup(
  {
    on_attach = function(bufnr)
      local gitsigns = require('gitsigns')

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gitsigns.nav_hunk('next')
        end
      end)

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gitsigns.nav_hunk('prev')
        end
      end)

      -- Actions
      map('n', '<leader>hs', gitsigns.stage_hunk)
      map('n', '<leader>hr', gitsigns.reset_hunk)
      map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
      map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
      map('n', '<leader>hS', gitsigns.stage_buffer)
      map('n', '<leader>hu', gitsigns.undo_stage_hunk)
      map('n', '<leader>hR', gitsigns.reset_buffer)
      map('n', '<leader>hp', gitsigns.preview_hunk)
      map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end)
      map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
      map('n', '<leader>hd', gitsigns.diffthis)
      map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
      map('n', '<leader>td', gitsigns.toggle_deleted)

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
  }
)

require('Comment').setup {
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
}
