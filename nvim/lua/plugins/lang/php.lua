vim.lsp.config("intelephense", {
  settings = {
    intelephense = {
      format = { enable = false },
      files = {
        maxSize = 2000000,
        exclude = {
          "**/vendor/**",
        },
      },
      diagnostics = {
        undefinedTypes = false,
      },
    }
  }
})
vim.lsp.enable("intelephense")