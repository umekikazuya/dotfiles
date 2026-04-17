return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = function()
    local dashboard = require("utils.dashboard")

    return {
      dashboard = {
        width = 100,
        preset = {
          header = [[
Say Hello!!
]],
          keys = dashboard.keys(),
        },
        formats = {
          header = { "%s", align = "center" },
        },
        sections = dashboard.sections(),
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
    }
  end,
}
