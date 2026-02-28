return {
  "lukas-reineke/indent-blankline.nvim",
  lazy = true,
  event = { "BufReadPost", "BufNewFile" },
  main = "ibl",
  opts = function()
    local hooks = require("ibl.hooks")
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      -- kanso-pearlの背景に近い、控えめなグレーのグラデーション
      vim.api.nvim_set_hl(0, "IblIndent1", { fg = "#D1D0CC" })
      vim.api.nvim_set_hl(0, "IblIndent2", { fg = "#C2C1BD" })
      vim.api.nvim_set_hl(0, "IblScope", { fg = "#8b5cf6", bold = true }) -- スコープ中の線は少し強調
    end)

    return {
      indent = {
        char = "▏",
        highlight = { "IblIndent1", "IblIndent2" },
      },
      scope = {
        highlight = "IblScope",
      },
    }
  end,
}
