return {
  {
    "j-hui/fidget.nvim",
    event = "UIEnter",
    opts = {
      progress = {
        suppress_on_insert = true,
        ignore_empty_message = true,
        ignore_done_already = true,
        display = {
          done_ttl = 2,
          done_icon = "",
          progress_icon = { "dots" },
        },
      },
      notification = {
        override_vim_notify = true,
        window = {
          border = "rounded",
          winblend = 20,
          normal_hl = "Normal",
          x_padding = 1,
          y_padding = 1,
        },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        options = {
          theme = "auto",
          globalstatus = true,
          component_separators = { left = " ", right = " " },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              color = {
                gui = "italic",
                fg = "#cccccc",
              },
              fmt = function(str)
                return str
              end,
              padding = { left = 1, right = 1 },
            },
          },
          lualine_b = { { "branch" } },
          lualine_c = {
            {
              "filename",
              padding = { left = 1, right = 1 },
              path = 1,
              symbols = {
                modified = " ●",
                readonly = " ",
                unnamed = "[No Name]",
              },
              color = { fg = "#3b3248", bg = "#cccccc", gui = "italic,bold" },
            },
          },
          lualine_y = {
            { "diagnostics" },
          },
          lualine_z = {
            {
              function()
                return vim.fn.line(".") .. "/" .. vim.fn.line("$")
              end,
              padding = { left = 1, right = 1 },
              color = { fg = "#3b3248", bg = "#ece8df" },
            },
          },
        },
      }
    end,
  },
}