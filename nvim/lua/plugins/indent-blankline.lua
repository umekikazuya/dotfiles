vim.pack.add({
  "https://github.com/lukas-reineke/indent-blankline.nvim.git",
}, { confirm = false })

local hooks = require("ibl.hooks")
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  -- kanso-pearlの背景に近い、控えめなグレーのグラデーション
  vim.api.nvim_set_hl(0, "IblIndent1", { fg = "#D8D5CF" })
  vim.api.nvim_set_hl(0, "IblIndent2", { fg = "#CBC6BC" })
  vim.api.nvim_set_hl(0, "IblScope", { fg = "#8b5cf6", bold = true }) -- スコープ中の線は少し強調
end)

require("ibl").setup({
  indent = {
    char = "▏",
    highlight = { "IblIndent1", "IblIndent2" },
  },
  scope = {
    highlight = "IblScope",
  },
})
