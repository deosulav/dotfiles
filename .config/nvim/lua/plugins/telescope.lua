return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
  },
  config = function()
    require('telescope').setup {
      pickers = {
        buffers = {
          sort_lastused = true,
          mappings = {
            i = {
              ["<C-d>"] = "delete_buffer",               -- Optional: to delete buffer with <C-d>
              ["<C-h>"] = "which_key"
            }
          },
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }
    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- telescope keymaps
    local builtin = require('telescope.builtin')
    local actions = require('telescope.actions')
    local is_hidden_visible = false
    local function open_find_files()
      local title_suffix = is_hidden_visible and 'hide hidden files' or 'show hidden files'
      local opts = {
        prompt_title = 'Find Files — Press <C-i> to ' .. title_suffix,
        attach_mappings = function(prompt_bufnr, map)
          map('i', '<C-i>', function()
            actions.close(prompt_bufnr)
            vim.schedule(function()
              is_hidden_visible = not is_hidden_visible
              open_find_files()
            end)
          end)
          return true
        end
      }
      if is_hidden_visible then
        opts.find_command = { 'rg', '--files', '--hidden', '-g', '!.git' }
      end
      builtin.find_files(opts)
    end

    vim.keymap.set('n', '<leader>ff', function()
      is_hidden_visible = false
      open_find_files()
    end, { noremap = true, desc = '[F]ind [F]iles' })

    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { noremap = true, desc = '[F]ind by [G]rep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { noremap = true, desc = '[F]ind [B]uffers ' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
    vim.keymap.set('n', '<leader>ft', builtin.builtin, { desc = '[F]ind [T]elescope Options' })
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
    vim.keymap.set('n', '<leader>fw', builtin.resume, { desc = '[F]ind current [W]ord across project' })
    vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = '[F]earch [R]ecent Files' })

    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end
}
