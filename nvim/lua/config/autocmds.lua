-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.filetype.add({
  extension = {
    inc = "php",
    theme = "php",
    module = "php",
  },
})

vim.api.nvim_create_augroup("MyAutoSave", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = "MyAutoSave",
  pattern = "*",
  callback = function()
    -- 編集可能かつファイル名がある場合のみ保存
    if vim.bo.modifiable and vim.fn.expand("%") ~= "" and vim.bo.filetype ~= "" then
      vim.cmd("silent! update")
      print("󰆓 Saved at " .. vim.fn.strftime("%H:%M:%S"))
    end
  end,
})
