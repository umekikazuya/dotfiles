vim.pack.add({
  "https://github.com/folke/persistence.nvim.git",
}, { confirm = false })

local persistence = require("persistence")
persistence.setup({})

-- stylua: ignore start
vim.keymap.set("n", "<leader>qs", function() persistence.load() end, { desc = "Restore Session" })
vim.keymap.set("n", "<leader>qS", function() persistence.select() end, { desc = "Select Session" })
vim.keymap.set("n", "<leader>ql", function() persistence.load({ last = true }) end, { desc = "Restore Last Session" })
vim.keymap.set("n", "<leader>qd", function() persistence.stop() end, { desc = "Don't Save Session" })
-- stylua: ignore end
