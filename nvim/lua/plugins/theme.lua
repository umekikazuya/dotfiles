return {
  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local colors = {
        accent = "#8b5cf6",
        accent_soft = "#ddd3fb",
        bg_cursorline = "#eee9f6",
        bg_float = "#ffffff",
        bg_noice = "#faf9f6",
        bg_picker = "#faf9f6",
        bg_search = "#e5dbfb",
        bg_visual = "#ebe4fb",
        border = "#c9c2b4",
        fg = "#3b3248",
        noice_border = "#d8c4ad",
        noice_title_cmdline = "#8b5cf6",
        noice_title_search = "#c68a4b",
        picker_border = "#d8c4ad",
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
            FloatBorder = { bg = colors.bg_float, fg = colors.accent },
            FloatTitle = { bg = colors.bg_float, fg = colors.accent, bold = true },
            IncSearch = { bg = colors.accent, fg = "#ffffff", bold = true },
            NoiceCmdlineIcon = { bg = colors.bg_noice, fg = colors.noice_title_cmdline },
            NoiceCmdlineIconCmdline = { bg = colors.bg_noice, fg = colors.noice_title_cmdline },
            NoiceCmdlineIconSearch = { bg = colors.bg_noice, fg = colors.noice_title_search },
            NoiceCmdlinePopup = { bg = colors.bg_noice, fg = colors.fg },
            NoiceCmdlinePopupBorder = { bg = colors.bg_noice, fg = colors.noice_border },
            NoiceCmdlinePopupBorderSearch = { bg = colors.bg_noice, fg = colors.noice_border },
            NoiceCmdlinePopupTitle = { bg = colors.bg_noice, fg = colors.noice_title_cmdline, bold = true },
            NoiceCmdlinePopupTitleCmdline = { bg = colors.bg_noice, fg = colors.noice_title_cmdline, bold = true },
            NoiceCmdlinePopupTitleSearch = { bg = colors.bg_noice, fg = colors.noice_title_search, bold = true },
            NoiceConfirm = { bg = colors.bg_noice, fg = colors.fg },
            NoiceConfirmBorder = { bg = colors.bg_noice, fg = colors.noice_border },
            NoicePopup = { bg = colors.bg_noice, fg = colors.fg },
            NoicePopupBorder = { bg = colors.bg_noice, fg = colors.noice_border },
            NormalFloat = { bg = colors.bg_float },
            Pmenu = { bg = colors.bg_float, fg = colors.fg },
            PmenuSel = { bg = colors.accent_soft, fg = colors.fg, bold = true },
            PmenuThumb = { bg = colors.border },
            Search = { bg = colors.bg_search, fg = colors.fg },
            SnacksPicker = { bg = colors.bg_picker, fg = colors.fg },
            SnacksPickerBorder = { bg = colors.bg_picker, fg = colors.picker_border },
            SnacksPickerBoxBorder = { bg = colors.bg_picker, fg = colors.picker_border },
            SnacksPickerDir = { fg = colors.accent },
            SnacksPickerInput = { bg = colors.bg_picker, fg = colors.fg },
            SnacksPickerInputBorder = { bg = colors.bg_picker, fg = colors.picker_border },
            SnacksPickerList = { bg = colors.bg_picker, fg = colors.fg },
            SnacksPickerPreview = { bg = colors.bg_picker, fg = colors.fg },
            SnacksPickerPreviewBorder = { bg = colors.bg_picker, fg = colors.picker_border },
            SnacksPickerPrompt = { fg = colors.accent, bold = true },
            SnacksPickerTitle = { bg = colors.bg_picker, fg = colors.accent, bold = true },
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
