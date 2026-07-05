return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    -- event = "LazyFile",
    event = { "BufNewFile", "BufReadPre" },
    opts = function()
      local tsc = require("treesitter-context")
      Snacks.toggle({
        name = "Treesitter Context",
        get = tsc.enabled,
        set = function(state)
          if state then
            tsc.enable()
          else
            tsc.disable()
          end
        end,
      }):map("<leader>ut")
      return {
        enable = true,
        multiwindow = false,
        max_lines = 0,
        min_window_height = 0,
        line_numbers = true,
        multiline_threshold = 20,
        trim_scope = "outer",
        mode = "cursor",
        separator = nil,
        zindex = 20,
        on_attach = nil,
      }
    end,
  },
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
  { "folke/noice.nvim", enabled = false }, -- TODO: 削除対象
  { "akinsho/bufferline.nvim", enabled = false }, -- TODO: 削除対象
}
