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
-- vim.lsp.config('php_ls', {
--   cmd = { 'php-language-server' },
--   filetypes = { 'php' },
--   root_markers = { 'composer.json', '.git' },
-- })