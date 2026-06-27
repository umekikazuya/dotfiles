vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

dofile(vim.fn.stdpath("config") .. "/lua/config/options.lua")
dofile(vim.fn.stdpath("config") .. "/lua/config/autocmds.lua")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.background = "light"
      require("kanso").setup()
      vim.cmd.colorscheme("kanso-pearl")
    end,
  },
  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = {
      "Kaiser-Yang/blink-cmp-git",
      "moyiz/blink-emoji.nvim",
    },
    opts = {
      keymap = { preset = "enter" },
      completion = {
        ghost_text = { enabled = false },
      },
      sources = {
        default = { "git", "path", "buffer", "emoji" },
        providers = {
          git = {
            module = "blink-cmp-git",
            name = "Git",
            enabled = function()
              return vim.tbl_contains({ "octo", "gitcommit", "markdown" }, vim.bo.filetype)
            end,
            opts = {
              commit = { triggers = { ";" } },
              git_centers = {
                github = { issue = {}, pull_request = {}, mention = {} },
              },
            },
          },
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            score_offset = 15,
            opts = {
              insert = true,
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
}, {
  checker = { enabled = false },
  change_detection = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tar", "tarPlugin", "zip", "zipPlugin", "vimball", "vimballPlugin", "tutor" },
    },
  },
})

vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("i", "<C-j>", "<Down>")
vim.keymap.set("i", "<C-k>", "<Up>")
vim.keymap.set("i", "<C-h>", "<Left>")
vim.keymap.set("i", "<C-l>", "<Right>")
vim.keymap.set({ "n", "v" }, "c", '"_c')
vim.keymap.set("n", "C", '"_C')
vim.keymap.set({ "n", "v" }, "x", '"_x')
vim.keymap.set("n", "X", '"_X')
