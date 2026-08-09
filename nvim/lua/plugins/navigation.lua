vim.pack.add({
  "https://github.com/nvim-mini/mini.icons.git",
  "https://github.com/stevearc/oil.nvim.git",
  "https://github.com/ibhagwan/fzf-lua.git",
}, { confirm = false })

-- mini.icons の setup オーナーはこのファイル（blink.lua は add のみ）
require("mini.icons").setup({})

---@module 'oil'
require("oil").setup({
  view_options = {
    show_hidden = true,
  },
  default_file_explorer = true,
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open Parent Directory" })

local fzf = require("fzf-lua")
local actions = require("fzf-lua.actions")
local qf = actions.file_sel_to_qf
fzf.setup({
  fzf_colors = true,
  fzf_opts = {
    ["--no-scrollbar"] = true,
  },
  winopts = {
    width = 0.8,
    height = 0.8,
    row = 0.5,
    col = 0.5,
    preview = {
      scrollchars = { "┃", "" },
    },
  },
  files = {
    cwd_prompt = false,
    actions = {
      ["alt-i"] = { actions.toggle_ignore },
      ["alt-h"] = { actions.toggle_hidden },
      ["ctrl-q"] = { fn = qf, prefix = "select-all" },
    },
  },
  grep = {
    actions = {
      ["alt-i"] = { actions.toggle_ignore },
      ["alt-h"] = { actions.toggle_hidden },
      ["ctrl-q"] = { fn = qf, prefix = "select-all" },
    },
  },
  lsp = {
    actions = {
      ["ctrl-q"] = { fn = qf, prefix = "select-all" },
    },
  },
})
fzf.register_ui_select()

vim.keymap.set("n", "<leader><leader>", fzf.files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>sg", fzf.live_grep, { desc = "Search by Grep" })
vim.keymap.set("n", "<leader>sb", fzf.buffers, { desc = "Search Buffers" })