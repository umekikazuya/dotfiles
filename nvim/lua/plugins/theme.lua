return {
  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.background = "light"
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          vim.api.nvim_set_hl(0, "iCursor", { bg = "#8b5cf6" })
          vim.api.nvim_set_hl(0, "CursorLine", { bg = "#eeede9" })
        end,
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanso-pearl",
    },
  },
}