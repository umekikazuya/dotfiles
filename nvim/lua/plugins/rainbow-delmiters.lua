return {
  "HiPhish/rainbow-delimiters.nvim",
  event = { "BufReadPost", "BufNewFile" },
  lazy = true,
  config = function()
    require("rainbow-delimiters.setup").setup({
      strategy = {
        [""] = "rainbow-delimiters.strategy.global",
      },
      query = {
        [""] = "rainbow-delimiters",
      },
      priority = {
        [""] = 210,
      },
      highlight = {
        "RainbowDelimiterYellow",
        "RainbowDelimiterViolet",
        "RainbowDelimiterBlue",
        "RainbowDelimiterGreen",
      },
    })
  end,
}