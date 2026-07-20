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

local function maybe_set_markdown_ft(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return
  end
  if vim.bo[bufnr].filetype ~= "" then
    return
  end
  if name:match("%.mdx$") then
    vim.bo[bufnr].filetype = "markdown.mdx"
  elseif name:match("%.md$") then
    vim.bo[bufnr].filetype = "markdown"
  end
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufEnter", "BufWinEnter" }, {
  pattern = "*",
  callback = function(ev)
    maybe_set_markdown_ft(ev.buf)
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