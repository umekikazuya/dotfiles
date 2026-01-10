return {
  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.background = "light"
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanso-pearl",
    },
  },
}