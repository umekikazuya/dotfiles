vim.lsp.config("bashls", {
  filetypes = { "bash", "sh", "zsh" },
})
vim.lsp.enable("bashls")