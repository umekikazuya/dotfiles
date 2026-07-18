vim.pack.add({
  "https://github.com/b0o/SchemaStore.nvim.git",
}, { confirm = false })

vim.lsp.config("yamlls", {
  before_init = function(_, new_config)
    new_config.settings.yaml.schemas = vim.tbl_deep_extend(
      "force",
      new_config.settings.yaml.schemas or {},
      require("schemastore").yaml.schemas()
    )
  end,
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      keyOrdering = false,
      format = {
        enable = true,
      },
      validate = true,
      schemaStore = {
        enable = false,
        url = "",
      },
    },
  },
})
vim.lsp.enable("yamlls")
