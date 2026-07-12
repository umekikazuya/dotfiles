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

        line_nr = "#d6cce4",

        bg_cursorline = "#e8e6e8",
        bg_float = "#ffffff",
        bg_noice = "#faf9f6",
        bg_picker = "#faf9f6",
        bg_search = "#e5dbfb",
        bg_visual = "#ebe4fb",

        border = "#c9c2b4",

        picker_file = "#6e6291",

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
            Normal = { bg = "NONE" },
            --     LineNr = { fg = palette.line_nr },
            --     CursorLine = { bg = palette.bg_cursorline },
            --     CursorLineNr = { fg = palette.picker_file, bold = true },

            --     FloatBorder = hl(palette.bg_float, palette.accent),
            --     FloatTitle = hl(palette.bg_float, palette.accent, { bold = true }),
            --     NormalFloat = { bg = palette.bg_float },

            --     IncSearch = hl(palette.accent, palette.white, { bold = true }),
            --     Search = hl(palette.bg_search, palette.fg),
            --     Visual = { bg = palette.bg_visual },
            --     WinSeparator = { fg = palette.border },
            --     iCursor = { bg = palette.accent },

            --     Pmenu = hl(palette.bg_float, palette.fg),
            --     PmenuSel = hl(palette.accent_soft, palette.fg, { bold = true }),
            --     PmenuThumb = { bg = palette.border },

            --     -- lsp
            --     LspSignatureActiveParameter = { bg = "NONE", underline = true },

            -- blink.cmp
            BlinkCmpMenu = hl("NONE", palette.fg),
            BlinkCmpMenuBorder = hl("NONE", palette.border),
            BlinkCmpMenuSelection = hl(palette.accent_soft, palette.fg),
            BlinkCmpLabel = { fg = palette.fg },
            BlinkCmpLabelMatch = { fg = palette.accent, bold = true },
            BlinkCmpDoc = hl("NONE", palette.fg),
            BlinkCmpDocBorder = hl("NONE", palette.border),
          }
        end,
      })
      vim.cmd.colorscheme("kanso-pearl")
    end,
  },
}