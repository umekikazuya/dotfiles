vim.schedule(function()
  vim.filetype.add({
    extension = { mdx = "markdown.mdx" },
  })
end)

vim.lsp.config("marksman", {})
vim.lsp.enable("marksman")