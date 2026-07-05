return {
  "ibhagwan/fzf-lua",
  dependencies = {
    { "nvim-mini/mini.icons", opts = {} },
  },
  init = function()
    local picker = {
      name = "fzf",
      commands = {
        files = "files",
      },
      open = function(command, opts)
        opts = opts or {}
        if opts.cmd == nil and command == "git_files" and opts.show_untracked then
          opts.cmd = "git ls-files --exclude-standard --cached --others"
        end
        require("fzf-lua")[command](opts)
      end,
    }
    LazyVim.pick.register(picker)

    LazyVim.on_very_lazy(function()
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "fzf-lua" } })
        require("fzf-lua").register_ui_select()
        return vim.ui.select(...)
      end
    end)
  end,
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
    }
  end,
  config = function(_, opts)
    require("fzf-lua").setup(opts)
    require("fzf-lua").register_ui_select()
  end,
}