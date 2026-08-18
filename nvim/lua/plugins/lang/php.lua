vim.lsp.config("intelephense", {
  settings = {
    intelephense = {
      format = { enable = false },
      files = {
        maxSize = 2000000,
      },
      diagnostics = {
        undefindTypes = false,
      },
    }
  }
})
vim.lsp.enable("intelephense")