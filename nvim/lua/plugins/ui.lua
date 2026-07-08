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
  { "folke/noice.nvim", enabled = false }, -- TODO: 削除対象
  { "akinsho/bufferline.nvim", enabled = false }, -- TODO: 削除対象
}
