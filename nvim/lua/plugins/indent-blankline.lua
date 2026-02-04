return {
  "lukas-reineke/indent-blankline.nvim",
  lazy = true,
  event = { "BufReadPost", "BufNewFile" },

  main = "ibl",
  ---@module "ibl"
  ---@type ibl.config
  config = function()
    local highlight = {
      "Red",
      "Orange",
      "Yellow",
      "Green",
      "Blue",
      "Purple",
    }
    local hooks = require("ibl.hooks")
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "Write", { fg = "#d1d9e0" })
      vim.api.nvim_set_hl(0, "Red", { fg = "#d1d9e0" })
      vim.api.nvim_set_hl(0, "Orange", { fg = "#d1d9e0" })
      vim.api.nvim_set_hl(0, "Yellow", { fg = "#d1d9e0" })
      vim.api.nvim_set_hl(0, "Green", { fg = "#d1d9e0" })
      vim.api.nvim_set_hl(0, "Blue", { fg = "#d1d9e0" })
      vim.api.nvim_set_hl(0, "Purple", { fg = "#d1d9e0" })
    end)

    require("ibl").setup({
      indent = { char = "▏", highlight = highlight },
      scope = { highlight = "Write" },
    })
  end,
}
