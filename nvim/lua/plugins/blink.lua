return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "Kaiser-Yang/blink-cmp-git",
      "moyiz/blink-emoji.nvim",
    },

    opts = {
      completion = {
        ghost_text = {
          enabled = false,
        },
      },
      sources = {
        default = { "git", "lsp", "path", "snippets", "buffer", "emoji" },
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
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            score_offset = 15,
            opts = {
              insert = true,
              ---@type string|table|fun():table
              trigger = function()
                return { ":" }
              end,
            },
            should_show_items = function()
              return vim.tbl_contains({ "gitcommit", "markdown" }, vim.o.filetype)
            end,
          },
        },
      },
    },
  },
}