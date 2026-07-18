vim.pack.add({
  "https://github.com/b0o/SchemaStore.nvim.git",
}, { confirm = false })

vim.lsp.config("jsonls", {
  cmd = { "vscode-json-languageserver", "--stdio" },
  before_init = function(_, new_config)
    new_config.settings.json.schemas = new_config.settings.json.schemas or {}
    vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
  end,
  settings = {
    json = {
      format = {
        enable = true,
      },
      validate = { enable = true },
    },
  },
})
vim.lsp.enable("jsonls")
