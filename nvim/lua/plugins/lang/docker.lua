vim.filetype.add({
  pattern = {
    -- Lua パターンでは "-" は量指定子なので %- にエスケープが必要
    ["docker%-compose.*%.yml"] = "yaml.docker-compose",
    ["docker%-compose.*%.yaml"] = "yaml.docker-compose",
    ["compose.*%.yml"] = "yaml.docker-compose",
    ["compose.*%.yaml"] = "yaml.docker-compose",
  },
})

-- Docker 公式 LSP（Dockerfile + Compose + Bake）。Compose は Microsoft 版と並存
vim.lsp.config("docker_language_server", {})
vim.lsp.enable("docker_language_server")

vim.lsp.config("docker_compose_language_service", {})
vim.lsp.enable("docker_compose_language_service")
