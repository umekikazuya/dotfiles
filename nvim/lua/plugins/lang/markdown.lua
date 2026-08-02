vim.schedule(function()
  vim.filetype.add({
    extension = { mdx = "markdown.mdx" },
  })
end)

vim.lsp.config("marksman", {})
vim.lsp.enable("marksman")

-- install/update 時に markdown-preview のアセットを導入する
vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("my.pack.build.markdown-preview", { clear = true }),
  callback = function(ev)
    if ev.data.spec.name ~= "markdown-preview.nvim" then
      return
    end
    if ev.data.kind ~= "install" and ev.data.kind ~= "update" then
      return
    end
    vim.cmd.packadd("markdown-preview.nvim")
    vim.fn["mkdp#util#install"]()
  end,
})

vim.pack.add({
  "https://github.com/iamcco/markdown-preview.nvim.git",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim.git",
}, { confirm = false })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(ev)
    vim.keymap.set("n", "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", {
      buffer = ev.buf,
      desc = "Markdown Preview",
    })
  end,
})

require("render-markdown").setup({
  code = {
    sign = false,
    width = "block",
    right_pad = 1,
  },
  heading = {
    sign = false,
    position = "inline",
  },
  quote = {
    repeat_linebreak = true,
  },
  completions = {
    lsp = { enabled = true },
  },
})
vim.api.nvim_exec_autocmds("FileType", { pattern = vim.bo.filetype, modeline = false })