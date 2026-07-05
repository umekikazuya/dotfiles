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
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "FocusLost", "BufLeave" }, {
  group = "MyAutoSave",
  pattern = "*",
  callback = function()
    -- 編集可能かつファイル名がある場合のみ保存
    if not (vim.bo.modifiable and vim.fn.expand("%") ~= "" and vim.bo.filetype ~= "") then
      return
    end
    -- 変更があるときだけ保存 & 通知
    if not vim.bo.modified then
      return
    end

    local write_ok, write_err = pcall(vim.cmd, "update")
    -- 保存失敗時は明示的に通知する
    if not write_ok or vim.bo.modified then
      vim.notify("Autosave failed: " .. tostring(write_err or "buffer is still modified"), vim.log.levels.WARN, {
        title = "autosave",
      })
      return
    end

    local ok, fidget = pcall(require, "fidget")
    if ok then
      fidget.notify("Saved", vim.log.levels.INFO, {
        ttl = 1,
        key = "autosave:" .. vim.api.nvim_get_current_buf(),
      })
    end
  end,
})
