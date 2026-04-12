-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- インサートモード中に 'jj' を素早く入力すると Esc とみなす
vim.keymap.set("i", "jj", "<Esc>", { desc = "Escape with jj" })
-- 入力モード中に Ctrl + h/j/k/l でカーソル移動
vim.keymap.set("i", "<C-j>", "<Down>", { desc = "Down" })
vim.keymap.set("i", "<C-k>", "<Up>", { desc = "Up" })
vim.keymap.set("i", "<C-h>", "<Left>", { desc = "Left" })
vim.keymap.set("i", "<C-l>", "<Right>", { desc = "Right" })


vim.keymap.set("n", "<leader>gr", function()
  require("utils.github").insert_saved_reply()
end, { desc = "GitHub Saved Reply" })
-- フローティグターミナル
vim.keymap.set("n", "<leader>ft", function()
  Snacks.terminal(nil, {
    win = {
      position = "float",
      backdrop = 90, -- 背景を少し暗くして集中しやすくする
      width = 0.8, -- 画面幅の80%
      height = 0.8, -- 画面高さの80%
      border = "rounded",
    },
  })
end, { desc = "Floating Terminal" })
