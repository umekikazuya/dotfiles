vim.pack.add({
  "https://github.com/folke/trouble.nvim.git",
  "https://github.com/folke/flash.nvim.git",
  "https://github.com/nvim-mini/mini.pairs.git",
  "https://github.com/nvim-mini/mini.surround.git",
  "https://github.com/nvim-mini/mini.ai.git",
  "https://github.com/Wansmer/treesj.git",
}, { confirm = false })

require("trouble").setup({ focus = true })
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics" })
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List" })

local flash = require("flash")
flash.setup({})
-- stylua: ignore start
vim.keymap.set({ "n", "x", "o" }, "s", function() flash.jump() end, { desc = "Flash" })
vim.keymap.set({ "n", "o", "x" }, "S", function() flash.treesitter() end, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function() flash.remote() end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function() flash.treesitter_search() end, { desc = "Treesitter Search" })
vim.keymap.set("c", "<c-s>", function() flash.toggle() end, { desc = "Toggle Flash Search" })
-- stylua: ignore end
vim.keymap.set({ "n", "o", "x" }, "<c-space>", function()
  flash.treesitter({
    actions = {
      ["<c-space>"] = "next",
      ["<BS>"] = "prev",
    },
  })
end, { desc = "Treesitter Incremental Selection" })

require("mini.pairs").setup({})

require("mini.surround").setup({
  silent = true,
  mappings = {
    add = "gsa", -- Add surrounding in Normal and Visual modes
    delete = "gsd", -- Delete surrounding
    find = "gsf", -- Find surrounding (to the right)
    find_left = "gsF", -- Find surrounding (to the left)
    highlight = "gsh", -- Highlight surrounding
    replace = "gsr", -- Replace surrounding
    update_n_lines = "gsn", -- Update `n_lines`
  },
})

require("mini.ai").setup({
  n_lines = 500,
})

require("treesj").setup({
  use_default_keymaps = false, -- デフォルトのキーマップ(gS/gJ)は使わず、<leader>mでトグルさせる
  max_join_length = 1000, -- 実質無制限に近くし、長いTableテストなども1行にまとめられるようにする
})
vim.keymap.set("n", "<leader>m", "<CMD>TSJToggle<CR>", { desc = "Toggle Split/Join" })
