-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
vim.filetype.add({
  extension = {
    module = 'php',
    inc = 'php',
    install = 'php',
    theme = 'php',
    profile = 'php',
    engine = 'php',
  },
})

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.cmd("filetype detect")
  end,
})

vim.api.nvim_create_augroup("MyAutoSave", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = "MyAutoSave",
  pattern = "*",
  callback = function(ev)
    vim.schedule(function()
      -- スニペットのプレースホルダ選択へ移る内部遷移では保存しない
      if vim.api.nvim_get_current_buf() ~= ev.buf or vim.fn.mode() ~= "n" then
        return
      end
      if vim.snippet.active() then
        vim.snippet.stop()
      end
      local is_oil = vim.bo.filetype == "oil"
      local is_normal_file = vim.bo.modifiable and vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) ~= ""
      if not (is_normal_file or is_oil) then
        return
      end
      -- 変更があるときだけ保存 & 通知
      if not vim.bo.modified then
        return
      end

      vim.b[ev.buf].autosave_in_progress = true
      local write_ok, write_err = pcall(vim.cmd, "update")
      vim.b[ev.buf].autosave_in_progress = false
      -- 保存失敗時は明示的に通知する
      if not write_ok or (not is_oil and vim.bo.modified) then
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
    end)
  end,
})