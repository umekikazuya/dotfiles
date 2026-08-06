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
    if not pcall(vim.treesitter.start, ev.buf) then
      return
    end
    local lang = vim.treesitter.language.get_lang(ev.match)
    if lang and vim.treesitter.query.get(lang, "indents") then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})