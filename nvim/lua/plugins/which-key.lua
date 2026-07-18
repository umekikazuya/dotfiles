vim.pack.add({
  "https://github.com/folke/which-key.nvim.git",
}, { confirm = false })

require("which-key").setup({
  preset = "helix",
})
