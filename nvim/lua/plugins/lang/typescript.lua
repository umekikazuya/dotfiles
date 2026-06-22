return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "typescript", "tsx", "javascript" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ts_ls = {},
      },
    },
  },

  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    opts = {},
  },

  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
