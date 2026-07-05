return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    { "<leader>e", false },
    { "<leader>E", false },
  },
  opts = function()
    return {
      dashboard = { enabled = false },
      notifier = { enabled = false },
    }
  end,
}
