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
