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

      local function apply_overrides()
        vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.bg_cursorline })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.accent, bold = true })
        vim.api.nvim_set_hl(0, "FloatBorder", { bg = colors.bg_float, fg = colors.border })
        vim.api.nvim_set_hl(0, "FloatTitle", { bg = colors.bg_float, fg = colors.accent, bold = true })
        vim.api.nvim_set_hl(0, "IncSearch", { bg = colors.accent, fg = "#ffffff", bold = true })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.bg_float })
        vim.api.nvim_set_hl(0, "Pmenu", { bg = colors.bg_float, fg = colors.fg })
        vim.api.nvim_set_hl(0, "PmenuSel", { bg = colors.accent_soft, fg = colors.fg, bold = true })
        vim.api.nvim_set_hl(0, "PmenuThumb", { bg = colors.border })
        vim.api.nvim_set_hl(0, "Search", { bg = colors.bg_search, fg = colors.fg })
        vim.api.nvim_set_hl(0, "SnacksTerminalBorder", { bg = colors.terminal_bg, fg = colors.terminal_border })
        vim.api.nvim_set_hl(0, "SnacksTerminalDark", { bg = colors.terminal_bg, fg = colors.terminal_fg })
        vim.api.nvim_set_hl(0, "Visual", { bg = colors.bg_visual })
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = colors.border })
        vim.api.nvim_set_hl(0, "iCursor", { bg = colors.accent })
      end

      vim.opt.background = "light"
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("kanso-custom-highlights", { clear = true }),
        pattern = "kanso*",
        callback = function()
          apply_overrides()
        end,
      })

      if vim.g.colors_name and vim.g.colors_name:match("^kanso") then
        apply_overrides()
      end
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanso-pearl",
    },
  },
}
