return {
  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local palette = {
        accent = "#8b5cf6",
        accent_soft = "#ddd3fb",
        fg = "#3b3248",
        white = "#ffffff",

        bg_cursorline = "#eee9f6",
        bg_float = "#ffffff",
        bg_noice = "#faf9f6",
        bg_picker = "#faf9f6",
        bg_search = "#e5dbfb",
        bg_visual = "#ebe4fb",

        border = "#c9c2b4",
        noice_border = "#d8c4ad",
        picker_border = "#d8c4ad",

        noice_title_cmdline = "#8b5cf6",
        noice_title_search = "#c68a4b",

        terminal_bg = "#1b1825",
        terminal_border = "#6b6284",
        terminal_fg = "#ddd6f4",
      }

      local function hl(bg, fg, opts)
        return vim.tbl_extend("force", { bg = bg, fg = fg }, opts or {})
      end

      vim.opt.background = "light"
      require("kanso").setup({
        overrides = function()
          return {
            CursorLine = { bg = palette.bg_cursorline },
            CursorLineNr = { fg = palette.accent, bold = true },

            FloatBorder = hl(palette.bg_float, palette.accent),
            FloatTitle = hl(palette.bg_float, palette.accent, { bold = true }),
            NormalFloat = { bg = palette.bg_float },

            IncSearch = hl(palette.accent, palette.white, { bold = true }),
            Search = hl(palette.bg_search, palette.fg),
            Visual = { bg = palette.bg_visual },
            WinSeparator = { fg = palette.border },
            iCursor = { bg = palette.accent },

            Pmenu = hl(palette.bg_float, palette.fg),
            PmenuSel = hl(palette.accent_soft, palette.fg, { bold = true }),
            PmenuThumb = { bg = palette.border },

            -- noice
            NoiceCmdlinePopup = hl(palette.bg_noice, palette.fg),
            NoiceCmdlinePopupBorder = hl(palette.bg_noice, palette.noice_border),
            NoiceCmdlinePopupBorderSearch = hl(palette.bg_noice, palette.noice_border),
            NoiceCmdlinePopupTitle = hl(palette.bg_noice, palette.noice_title_cmdline, { bold = true }),
            NoiceCmdlinePopupTitleCmdline = hl(palette.bg_noice, palette.noice_title_cmdline, { bold = true }),
            NoiceCmdlinePopupTitleSearch = hl(palette.bg_noice, palette.noice_title_search, { bold = true }),
            NoiceCmdlineIcon = hl(palette.bg_noice, palette.noice_title_cmdline),
            NoiceCmdlineIconCmdline = hl(palette.bg_noice, palette.noice_title_cmdline),
            NoiceCmdlineIconSearch = hl(palette.bg_noice, palette.noice_title_search),
            NoiceConfirm = hl(palette.bg_noice, palette.fg),
            NoiceConfirmBorder = hl(palette.bg_noice, palette.noice_border),
            NoicePopup = hl(palette.bg_noice, palette.fg),
            NoicePopupBorder = hl(palette.bg_noice, palette.noice_border),

            -- snacks picker
            SnacksPicker = hl(palette.bg_picker, palette.fg),
            SnacksPickerBorder = hl(palette.bg_picker, palette.picker_border),
            SnacksPickerBoxBorder = hl(palette.bg_picker, palette.picker_border),
            SnacksPickerInput = hl(palette.bg_picker, palette.fg),
            SnacksPickerInputBorder = hl(palette.bg_picker, palette.picker_border),
            SnacksPickerList = hl(palette.bg_picker, palette.fg),
            SnacksPickerPreview = hl(palette.bg_picker, palette.fg),
            SnacksPickerPreviewBorder = hl(palette.bg_picker, palette.picker_border),
            SnacksPickerTitle = hl(palette.bg_picker, palette.accent, { bold = true }),
            SnacksPickerPrompt = { fg = palette.accent, bold = true },
            SnacksPickerDir = { fg = palette.accent },

            -- snacks terminal
            SnacksTerminalBorder = hl(palette.terminal_bg, palette.terminal_border),
            SnacksTerminalDark = hl(palette.terminal_bg, palette.terminal_fg),
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
