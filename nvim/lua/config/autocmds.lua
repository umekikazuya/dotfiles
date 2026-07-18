-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
vim.filetype.add({
  extension = {
    inc = "php",
    theme = "php",
    module = "php",
  },
})

vim.api.nvim_create_augroup("MyAutoSave", { clear = true })
vim.api.nvim_create_autocmd("InsertLeave", {
  group = "MyAutoSave",
  pattern = "*",
  callback = function()
    if vim.snippet.active() then
      vim.snippet.stop()
    end
    -- 編集可能な通常ファイルだけを保存する
    if not (vim.bo.modifiable and vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) ~= "") then
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
