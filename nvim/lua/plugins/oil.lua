return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    view_options = {
      show_hidden = true,
    },
    default_file_explorer = true,
  },
  init = function()
    vim.api.nvim_create_autocmd("VimEnter", {
      nested = true,
      callback = function()
        if vim.fn.argc() == 0 then
          require("oil")
          vim.cmd.edit(vim.fn.getcwd())
        end
      end,
    })
  end,
  keys = {
    { "-", "<CMD>Oil<CR>", desc = "Open Parent Directory" },
  },
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
}