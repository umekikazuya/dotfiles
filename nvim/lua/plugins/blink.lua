return {
  {
    "saghen/blink.cmp",
    branch = "v2",
    build = function()
      if vim.fn.executable("cargo") == 1 then
        require("blink.cmp").build({ force = true }):pwait()
      end
    end,
    dependencies = {
      "saghen/blink.lib",
      "Kaiser-Yang/blink-cmp-git",
      "rafamadriz/friendly-snippets",
      "nvim.mini/mini.icons",
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "none",
        ["<CR>"] = { "accept", "fallback" },
        ["<C-y>"] = { "accept", "fallback" },

        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },

        ["<C-e>"] = { "hide", "show", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      },
      fuzzy = {
        implementation = vim.fn.executable("cargo") == 1 and "rust" or "lua",
      },
      cmdline = {
        enabled = true,
        completion = {
          ghost_text = { enabled = true },
        },
      },
      appearance = { use_nvim_cmp_as_default = true },
      completion = {
        ghost_text = {
          enabled = false,
        },
        menu = {
          border = "rounded",
          draw = {
            components = {
              kind_icon = {
                text = function(ctx)
                  local ok, mini_icons = pcall(require, "mini.icons")
                  if not ok then
                    return ctx.kind_icon .. ctx.icon_gap
                  end
                  local icon = mini_icons.get("lsp", ctx.kind)
                  return (icon or ctx.kind_icon) .. ctx.icon_gap
                end,
              },
            },
          },
        },
        documentation = {
          window = {
            border = "rounded",
          },
        },
      },
      snippets = {
        preset = "default",
      },
      sources = {
        default = { "git", "lsp", "path", "snippets", "buffer" },
        providers = {

          git = {
            module = "blink-cmp-git",
            name = "Git",
            enabled = function()
              return vim.tbl_contains({ "octo", "gitcommit", "markdown" }, vim.bo.filetype)
            end,
            --- @module 'blink-cmp-git'
            --- @type blink-cmp-git.Options
            opts = {
              commit = {
                triggers = { ";" },
              },
              git_centers = {
                github = {
                  issue = {},
                  pull_request = {},
                  mention = {},
                },
              },
            },
          },
          -- emoji = {
          --   module = "blink-emoji",
          --   name = "Emoji",
          --   score_offset = 15,
          --   opts = {
          --     insert = true,
          --     ---@type string|table|fun():table
          --     trigger = function()
          --       return { ":" }
          --     end,
          --   },
          --   should_show_items = function()
          --     return vim.tbl_contains({ "gitcommit", "markdown" }, vim.o.filetype)
          --   end,
          -- },
        },
      },
    },
  },
}