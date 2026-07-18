vim.pack.add({
  "https://github.com/HiPhish/rainbow-delimiters.nvim.git",
}, { confirm = false })

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
