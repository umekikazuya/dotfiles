return {
  {
    "saghen/blink.cmp",
    branch = "v2",
    dependencies = {
      "saghen/blink.lib",
      "Kaiser-Yang/blink-cmp-git",
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
        implementation = "prefer_rust_with_warning",
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
        },
        documentation = {
          window = {
            border = "rounded",
          },
        },
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