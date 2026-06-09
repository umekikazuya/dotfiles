return {
  "folke/noice.nvim",
  opts = {
    cmdline = {
      format = {
        cmdline = { view = "cmdline_popup" },
        search_down = { view = "cmdline_popup" },
        search_up = { view = "cmdline_popup" },
      },
    },
    views = {
      cmdline_popup = {
        position = {
          row = "20%",
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
        border = {
          style = { " ", "━", " ", " ", " ", "━", " ", " " },
          padding = { 0, 1 },
        },
        win_options = {},
      },
    },
  },
}
