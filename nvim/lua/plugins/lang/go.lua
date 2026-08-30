vim.lsp.config("gopls", {
  settings = {
    gopls = {
      gofumpt = true,
      codelenses = {
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        ignoredError = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      analyses = {
        ST1000 = false,
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        nonewvars = true,
        fillreturns = true,
      },
      usePlaceholders = true,
      staticcheck = true,
      directoryFilters = { "-**/.git", "-.vscode", "-.idea", "-.vscode-test", "-**/node_modules", "-**/cdk.out" },
      semanticTokens = true,
    },
  },
})
vim.lsp.enable("gopls")