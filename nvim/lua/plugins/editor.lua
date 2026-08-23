vim.pack.add({
  "https://github.com/folke/trouble.nvim.git",
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

require("mini.pairs").setup({})

require("mini.surround").setup({
  silent = true,
  mappings = {
    add = "sa",            -- Add surrounding in Normal and Visual modes
    delete = "sd",         -- Delete surrounding
    find = "sf",           -- Find surrounding (to the right)
    find_left = "sF",      -- Find surrounding (to the left)
    highlight = "sh",      -- Highlight surrounding
    replace = "sr",        -- Replace surrounding
    update_n_lines = "sn", -- Update `n_lines`
  },
})

require("mini.ai").setup({
  n_lines = 500,
})

require("treesj").setup({
  use_default_keymaps = false, -- デフォルトのキーマップ(gS/gJ)は使わず、<leader>mでトグルさせる
  max_join_length = 1000,      -- 実質無制限に近くし、長いTableテストなども1行にまとめられるようにする
})
vim.keymap.set("n", "<leader>m", "<CMD>TSJToggle<CR>", { desc = "Toggle Split/Join" })
