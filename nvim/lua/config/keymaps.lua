-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- インサートモード中に 'jj' を素早く入力すると Esc とみなす
vim.keymap.set("i", "jj", "<Esc>", { desc = "Escape with jj" })