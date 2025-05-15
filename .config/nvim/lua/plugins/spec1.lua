return {
  -- the colorscheme
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     vim.cmd([[colorscheme tokyonight]])
  --   end,
  -- },
  {
    "Mofiqul/vscode.nvim",
    config = function()
      local c = require('vscode.colors').get_colors()
      require('vscode').setup()
    end
  },
  {
    "folke/which-key.nvim",
    lazy  = true,
    event = "VeryLazy",
    opts  = {
    },
    keys  = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    "dstein64/vim-startuptime",
    lazy = true,
    event = "VeryLazy",
    cmd = "StartupTime",
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    lazy = true,
    event = "VeryLazy",
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Auto pairs JSX tags
    'windwp/nvim-ts-autotag',
    lazy = true,
    event = 'VeryLazy',
    config = function()
      require('nvim-ts-autotag').setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false
        },
        filetypes = { "html", "xml", "tsx", "jsx" },
      })
    end
  },
  {
    "hrsh7th/nvim-cmp",
    lazy = true,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local cmp = require("cmp")
      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-o>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        }
        ),
      })
    end,
  },
  {
    'windwp/nvim-autopairs',
    lazy = true,
    event = "VeryLazy",
    config = function()
      require('nvim-autopairs').setup({
        disable_filetype = { "TelescopePrompt", "vim" }, -- Disable in specific file types
        check_ts = true,                                 -- Use treesitter for better pairing
      })

      -- If using nvim-cmp, integrate it with autopairs for better completion
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end
  },
  {
    'kylechui/nvim-surround',
    lazy = true,
    event = "VeryLazy",
    config = function()
      require('nvim-surround').setup()
    end
  },
  { "nvim-tree/nvim-web-devicons",              lazy = true, event = "VeryLazy" },
  {
    "Wansmer/treesj",
    lazy = true,
    event = "VeryLazy",
    keys = {
      { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    },
    opts = { use_default_keymaps = false, max_join_length = 150 },
  },
  -- local plugins
  -- you can use a custom url to fetch a plugin
  { url = "git@github.com:folke/noice.nvim.git" },
}
