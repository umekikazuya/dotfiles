return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    dashboard = {
      preset = {
        header = [[
Say Hello!!
]],
      },
      formats = {
        header = { "%s", align = "center" },
      },
      enabled = true,
    },
    picker = {
      sources = {
        files = {
          hidden = true,
          ignored = false,
        },
      },
    },
  },
}
