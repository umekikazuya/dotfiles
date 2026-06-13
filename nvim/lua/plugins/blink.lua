return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "Kaiser-Yang/blink-cmp-git",
    },

    opts = {
      completion = {
        ghost_text = {
          enabled = false,
        },
        -- list = {
        --   selection = { preselect = false, auto_insert = false },
        -- },
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
                triggers = { ":" },
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
        },
      },
    },
  },
}
