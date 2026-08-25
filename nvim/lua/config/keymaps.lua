-- Add any additional keymaps here

-- インサートモード中に 'jj' を素早く入力すると Esc とみなす
vim.keymap.set("i", "jj", "<Esc>", { desc = "Escape with jj" })
-- 入力モード中に Ctrl + l でカーソル移動
vim.keymap.set("i", "<C-l>", "<Right>", { desc = "Right" })

-- cをレジスタに入れない
vim.keymap.set({ "n", "v" }, "c", '"_c')
-- 大文字Cをレジスタに入れない
vim.keymap.set("n", "C", '"_C')
-- xをレジスタに入れない
vim.keymap.set({ "n", "v" }, "x", '"_x')
-- 大文字Xをレジスタに入れない
vim.keymap.set("n", "X", '"_X')

vim.keymap.set("n", "<leader>gr", function()
  require("utils.github").insert_saved_reply()
end, { desc = "GitHub Saved Reply" })

vim.keymap.set("n", "<leader>pwd", function()
  local path = vim.fn.expand("%:.")
  if path == "" then
    vim.notify("Current buffer has no file path", vim.log.levels.WARN, { title = "keymaps" })
    return
  end
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path, vim.log.levels.INFO, { title = "keymaps" })
end, { desc = "Copy Relative Path" })