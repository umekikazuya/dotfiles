vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter.git",
}, { confirm = false })

local ts = require("nvim-treesitter")

ts.install({
  "dockerfile",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "javascript",
  "json5",
  "php",
  "tsx",
  "typescript",
  "yaml",
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("my.treesitter", { clear = true }),
  callback = function(ev)
    if pcall(vim.treesitter.start, ev.buf) then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})