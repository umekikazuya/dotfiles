vim.g.tmux_navigator_no_mappings = 1

vim.pack.add({
  "https://github.com/christoomey/vim-tmux-navigator.git",
}, { confirm = false })

vim.keymap.set("n", "<F1>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Navigate Left" })
vim.keymap.set("n", "<F2>", "<cmd>TmuxNavigateDown<cr>", { desc = "Navigate Down" })
vim.keymap.set("n", "<F3>", "<cmd>TmuxNavigateUp<cr>", { desc = "Navigate Up" })
vim.keymap.set("n", "<F4>", "<cmd>TmuxNavigateRight<cr>", { desc = "Navigate Right" })
