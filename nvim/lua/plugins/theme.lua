return {
  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local colors = {
        accent = "#8b5cf6",
        accent_soft = "#ddd3fb",
        bg_cursorline = "#ece8df",
        bg_float = "#f7f2ea",
        bg_search = "#e5dbfb",
        bg_visual = "#ebe4fb",
        border = "#c9c2b4",
        fg = "#3b3248",
        terminal_bg = "#1b1825",
        terminal_border = "#6b6284",
        terminal_fg = "#ddd6f4",
      }

      vim.opt.background = "light"
      require("kanso").setup({
        overrides = function()
          return {
            CursorLine = { bg = colors.bg_cursorline },
            CursorLineNr = { fg = colors.accent, bold = true },
            FloatBorder = { bg = colors.bg_float, fg = colors.border },
            FloatTitle = { bg = colors.bg_float, fg = colors.accent, bold = true },
            IncSearch = { bg = colors.accent, fg = "#ffffff", bold = true },
            NormalFloat = { bg = colors.bg_float },
            Pmenu = { bg = colors.bg_float, fg = colors.fg },
            PmenuSel = { bg = colors.accent_soft, fg = colors.fg, bold = true },
            PmenuThumb = { bg = colors.border },
            Search = { bg = colors.bg_search, fg = colors.fg },
            SnacksTerminalBorder = { bg = colors.terminal_bg, fg = colors.terminal_border },
            SnacksTerminalDark = { bg = colors.terminal_bg, fg = colors.terminal_fg },
            Visual = { bg = colors.bg_visual },
            WinSeparator = { fg = colors.border },
            iCursor = { bg = colors.accent },
          }
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
  -- タブラインを非表示
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
}