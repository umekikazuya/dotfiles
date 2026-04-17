return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    picker = "snacks",
    enable_builtin = true,
    default_mappings = true,
    mappings = {
      review_diff = {
        add_review_comment = { lhs = "<localleader>ca", desc = "add a new review comment", mode = { "n", "x" } },
        add_review_suggestion = { lhs = "<localleader>sa", desc = "add a new review suggestion", mode = { "n", "x" } },
        add_comment = { lhs = "ca", desc = "add a new review comment" },
        add_suggestion = { lhs = "sa", desc = "add a new review suggestion" },
        delete_comment = { lhs = "cd", desc = "delete a review comment" },
        next_thread = { lhs = "]c", desc = "move to next thread" },
        prev_thread = { lhs = "[c", desc = "move to previous thread" },
        select_next_entry = { lhs = "]q", desc = "move to next changed file" },
        select_prev_entry = { lhs = "[q", desc = "move to previous changed file" },
        close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
        toggle_viewed = { lhs = "<leader>tv", desc = "toggle viewed state" },
      },
    },
  },
  config = function(_, opts)
    require("octo").setup(opts)

    -- Treesitterの登録
    vim.treesitter.language.register("markdown", "octo")

    -- Autocmdの設定
    vim.api.nvim_create_autocmd("ExitPre", {
      group = vim.api.nvim_create_augroup("octo_exit_pre", { clear = true }),
      callback = function()
        local keep = { "octo" }
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.tbl_contains(keep, vim.bo[buf].filetype) then
            vim.bo[buf].buftype = ""
          end
        end
      end,
    })
  end,
  keys = {
    { "<leader>oi", "<CMD>Octo issue list<CR>", desc = "List GitHub Issues" },
    { "<leader>op", "<CMD>Octo pr list<CR>", desc = "List GitHub PullRequests" },
    { "<leader>od", "<CMD>Octo discussion list<CR>", desc = "List GitHub Discussions" },
    { "<leader>on", "<CMD>Octo notification list<CR>", desc = "List GitHub Notifications" },
    {
      "<leader>os",
      function()
        require("octo.utils").create_base_search_command({ include_current_repo = true })
      end,
      desc = "Search GitHub",
    },
  },
}
