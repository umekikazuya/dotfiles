return {
  "Wansmer/treesj",
  keys = {
    { "<leader>m", "<CMD>TSJToggle<CR>", desc = "Toggle Split/Join" },
  },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    use_default_keymaps = false, -- デフォルトのキーマップ(gS/gJ)は使わず、<leader>mでトグルさせる
    max_join_length = 1000, -- 実質無制限に近くし、長いTableテストなども1行にまとめられるようにする
  },
}
