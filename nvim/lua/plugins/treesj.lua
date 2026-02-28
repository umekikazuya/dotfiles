return {
  "Wansmer/treesj",
  keys = {
    { "<leader>m", "<CMD>TSJToggle<CR>", desc = "Toggle Split/Join" },
  },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    use_default_keymaps = false, -- デフォルトのキーマップ(gS/gJ)は使わず、<leader>mでトグルさせる
    max_join_length = 120, -- 120文字までは1行にまとめられるようにする
  },
}
