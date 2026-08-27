vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim.git",
  "https://github.com/lewis6991/gitsigns.nvim.git",
  "https://github.com/ruifm/gitlinker.nvim.git",
  "https://github.com/pwntester/octo.nvim.git",
  "https://github.com/sindrets/diffview.nvim.git",
}, { confirm = false })

require("gitsigns").setup({
  current_line_blame = false,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map("n", "]h", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gs.nav_hunk("next")
      end
    end, "Next Hunk")
    map("n", "[h", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gs.nav_hunk("prev")
      end
    end, "Prev Hunk")
    map("n", "]H", function()
      gs.nav_hunk("last")
    end, "Last Hunk")
    map("n", "[H", function()
      gs.nav_hunk("first")
    end, "First Hunk")

    map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
    map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
    map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
    map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
    map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
    map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
    map("n", "<leader>ghb", function()
      gs.blame_line({ full = true })
    end, "Blame Line")
    map("n", "<leader>ghB", gs.blame, "Blame Buffer")
    map("n", "<leader>ghd", gs.diffthis, "Diff This")
    map("n", "<leader>ghD", function()
      gs.diffthis("~")
    end, "Diff This ~")
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select Hunk")
  end,
})

local gitlinker_initialized = false
local function ensure_gitlinker()
  if gitlinker_initialized then
    return true
  end
  local ok, gitlinker = pcall(require, "gitlinker")
  if not ok then
    vim.notify("Failed to load gitlinker", vim.log.levels.ERROR)
    return false
  end
  gitlinker.setup({ mappings = nil })
  gitlinker_initialized = true
  return true
end

vim.keymap.set("n", "<leader>gB", function()
  if not ensure_gitlinker() then
    return
  end
  require("gitlinker").get_buf_range_url("n", {
    action_callback = require("gitlinker.actions").open_in_browser,
  })
end, { desc = "Git Browse (open)" })
vim.keymap.set("x", "<leader>gB", function()
  if not ensure_gitlinker() then
    return
  end
  require("gitlinker").get_buf_range_url("v", {
    action_callback = require("gitlinker.actions").open_in_browser,
  })
end, { desc = "Git Browse (open)" })
vim.keymap.set("n", "<leader>gY", function()
  if not ensure_gitlinker() then
    return
  end
  require("gitlinker").get_buf_range_url("n")
end, { desc = "Git Browse (copy)" })
vim.keymap.set("x", "<leader>gY", function()
  if not ensure_gitlinker() then
    return
  end
  require("gitlinker").get_buf_range_url("v")
end, { desc = "Git Browse (copy)" })

local diffview_initialized = false
local function ensure_diffview()
  if diffview_initialized then
    return true
  end
  vim.cmd.packadd("diffview.nvim")
  local ok, diffview = pcall(require, "diffview")
  if not ok then
    vim.notify("Failed to load diffview", vim.log.levels.ERROR)
    return false
  end
  diffview.setup({ use_icons = false })
  diffview_initialized = true
  return true
end

for _, cmd_name in ipairs({ "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewFocusFiles", "DiffviewToggleFiles" }) do
  if vim.fn.exists(":" .. cmd_name) == 2 then
    goto continue
  end
  vim.api.nvim_create_user_command(cmd_name, function(opts)
    pcall(vim.api.nvim_del_user_command, cmd_name)
    if not ensure_diffview() then
      return
    end
    vim.cmd(("%s %s"):format(cmd_name, opts.args))
  end, { nargs = "*", desc = ("Lazy %s"):format(cmd_name) })
  ::continue::
end

local function resolve_octo_default_remotes()
  local remotes = vim.fn.systemlist({ "git", "remote" })
  if vim.v.shell_error ~= 0 or #remotes == 0 then
    return { "origin", "upstream" }
  end

  local order = {}
  local seen = {}

  local upstream = vim.fn.systemlist({ "git", "rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{upstream}" })[1]
  local upstream_remote = upstream and upstream:match("^([^/]+)/")
  if upstream_remote and upstream_remote ~= "" then
    table.insert(order, upstream_remote)
    seen[upstream_remote] = true
  end

  for _, remote in ipairs(remotes) do
    if remote ~= "" and not seen[remote] then
      table.insert(order, remote)
    end
  end

  return order
end

local octo_initialized = false
local function ensure_octo()
  if octo_initialized then
    return
  end

  require("octo").setup({
    picker = "fzf-lua",
    enable_builtin = true,
    default_mappings = true,
    default_remote = resolve_octo_default_remotes(),
    file_panel = {
      icons = function(name, _ext)
        local icon, hl = require("mini.icons").get("file", name)
        return icon, hl
      end,
    },
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
  })

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

  octo_initialized = true
end

-- octo.nvim は plugin/ を持たず、:Octo は setup() 内で作られる。
-- 起動時に setup() を走らせると約65ms かかるため、軽いスタブだけ登録しておき、
-- 初回実行時に本体を読み込む（setup() が同名でこのコマンドを上書きする）。
local OCTO_SUBCOMMANDS = {
  "assignee",
  "author",
  "card",
  "comment",
  "discussion",
  "gist",
  "issue",
  "label",
  "milestone",
  "notification",
  "parent",
  "poll",
  "pr",
  "reaction",
  "release",
  "repo",
  "review",
  "reviewer",
  "run",
  "search",
  "thread",
  "type",
  "workflow",
}

vim.api.nvim_create_user_command("Octo", function(opts)
  ensure_octo()
  local range = opts.range == 2 and (opts.line1 .. "," .. opts.line2) or (opts.range == 1 and opts.line1 or "")
  vim.cmd(("%sOcto %s"):format(range, opts.args))
end, {
  nargs = "*",
  range = true,
  desc = "Octo (遅延読み込み)",
  -- 第1引数のみ静的補完。初回実行後は octo 本体の補完に置き換わる
  complete = function(arglead, cmdline)
    if not cmdline:match("^%s*%d*,?%d*Octo%s+%S*$") then
      return {}
    end
    return vim.tbl_filter(function(cmd)
      return cmd:find(arglead, 1, true) == 1
    end, OCTO_SUBCOMMANDS)
  end,
})

vim.keymap.set("n", "<leader>oi", function()
  ensure_octo()
  vim.cmd("Octo issue list")
end, { desc = "List GitHub Issues" })
vim.keymap.set("n", "<leader>op", function()
  ensure_octo()
  vim.cmd("Octo pr list")
end, { desc = "List GitHub PullRequests" })
vim.keymap.set("n", "<leader>od", function()
  ensure_octo()
  vim.cmd("Octo discussion list")
end, { desc = "List GitHub Discussions" })
vim.keymap.set("n", "<leader>on", function()
  ensure_octo()
  vim.cmd("Octo notification list")
end, { desc = "List GitHub Notifications" })
vim.keymap.set("n", "<leader>os", function()
  ensure_octo()
  require("octo.utils").create_base_search_command({ include_current_repo = true })
end, { desc = "Search GitHub" })
