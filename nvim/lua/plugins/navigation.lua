return {
  {
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
          if vim.fn.argc() ~= 0 then
            return
          end
          vim.cmd("Oil " .. vim.fn.getcwd())
        end,
      })
    end,
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Open Parent Directory" },
    },
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      { "nvim-mini/mini.icons", opts = {} },
    },
    keys = {
      {
        "<leader><leader>",
        function()
          require("fzf-lua").files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>sg",
        function()
          require("fzf-lua").live_grep()
        end,
        desc = "Search by Grep",
      },
      {
        "<leader>sb",
        function()
          require("fzf-lua").buffers()
        end,
        desc = "Search Buffers",
      },
    },
    opts = function()
      local actions = require("fzf-lua.actions")
      return {
        fzf_colors = true,
        fzf_opts = {
          ["--no-scrollbar"] = true,
        },
        winopts = {
          width = 0.8,
          height = 0.8,
          row = 0.5,
          col = 0.5,
          preview = {
            scrollchars = { "┃", "" },
          },
        },
        files = {
          cwd_prompt = false,
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        grep = {
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        -- lsp = { keymap = false },
      }
    end,
    config = function(_, opts)
      require("fzf-lua").setup(opts)
      require("fzf-lua").register_ui_select()
    end,
  },
}