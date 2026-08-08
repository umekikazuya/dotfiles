vim.pack.add({
  "https://github.com/gbprod/yanky.nvim.git",
}, { confirm = false })

require("yanky").setup({
  system_clipboard = {
    sync_with_ring = not vim.env.SSH_CONNECTION,
  },
  highlight = { timer = 150 },
})

local map = vim.keymap.set
-- stylua: ignore start
map({ "n", "x" }, "y", "<Plug>(YankyYank)", { desc = "Yank Text" })
map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Put Text After Cursor" })
map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Put Text Before Cursor" })
map("n", "<C-p>", "<Plug>(YankyCycleForward)", { desc = "Cycle Forward Through Yank History" })
map("n", "<C-n>", "<Plug>(YankyCycleBackward)", { desc = "Cycle Backward Through Yank History" })
-- stylua: ignore end