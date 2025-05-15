return {
  "nvim-treesitter/nvim-treesitter",
  lazy = true,
  event = "VeryLazy",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "typescript", "tsx", "rust", "html", "go" },
      sync_install = false,
      highlight = { enable = true },
      -- autotag = { enable = true },
      indent = { enable = true },
    })
  end
}
