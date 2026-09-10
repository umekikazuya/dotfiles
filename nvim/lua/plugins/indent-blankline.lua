vim.pack.add({
  "https://github.com/lukas-reineke/indent-blankline.nvim.git",
}, { confirm = false })

require("ibl").setup({
  scope = {
    enabled = true,
  },
})