local M = {}

local function has(cmd)
  return vim.fn.executable(cmd) == 1
end

local function shell(script)
  return { "sh", "-lc", script }
end

local function in_git_repo()
  local cwd = vim.uv.cwd() or vim.fn.getcwd()
  return vim.fs.find(".git", { path = cwd, upward = true, limit = 1 })[1] ~= nil
end

local function trim(text)
  return (text or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function repo_slug()
  if not in_git_repo() then
    return nil
  end

  local result = vim.system({ "git", "remote", "get-url", "origin" }, { text = true }):wait()
  if result.code ~= 0 then
    return nil
  end

  local remote = trim(result.stdout):gsub("%.git$", "")
  return remote:match("github%.com[:/](.+/.+)$")
end

local function notify(message)
  vim.notify(message, vim.log.levels.INFO, { title = "dashboard" })
end

function M.open_my_prs()
  if not has("gh") then
    notify("gh is not available")
    return
  end

  vim.fn.jobstart({ "gh", "pr", "list", "--author", "@me", "--web" }, { detach = true })
end

function M.open_workflows()
  local slug = repo_slug()
  if not slug then
    notify("GitHub repository not found")
    return
  end

  vim.ui.open("https://github.com/" .. slug .. "/actions")
end

function M.keys()
  return {
    { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
  }
end

local function github_sections()
  return {
    {
      icon = " ",
      title = "My PRs",
      section = "terminal",
      cmd = shell(
        "gh pr list --author @me -L 3 --json number,title,headRefName "
          .. "--template '{{range .}}{{printf \"#%-4v %-18.18s %.40s\\n\" .number .headRefName .title}}{{else}}No open PRs\\n{{end}}' "
          .. "2>/dev/null || printf 'GitHub data unavailable\\n'"
      ),
      key = "p",
      action = M.open_my_prs,
      enabled = function()
        return has("gh") and in_git_repo()
      end,
      height = 3,
      ttl = 5 * 60,
      indent = 2,
    },
    {
      icon = "󰙨 ",
      title = "Workflow Runs",
      section = "terminal",
      cmd = shell(
        "gh run list -L 3 --json status,conclusion,workflowName,headBranch "
          .. "--template '{{range .}}{{printf \"%-10.10s %-10.10s %-18.18s %.18s\\n\" .status .conclusion .workflowName .headBranch}}{{else}}No workflow runs\\n{{end}}' "
          .. "2>/dev/null || printf 'Workflow data unavailable\\n'"
      ),
      key = "w",
      action = M.open_workflows,
      enabled = function()
        return has("gh") and in_git_repo()
      end,
      height = 3,
      ttl = 5 * 60,
      indent = 2,
    },
  }
end

function M.sections()
  return {
    { section = "header", padding = 0 },
    github_sections(),
    { section = "keys", gap = 0, padding = 0 },
    { section = "startup", padding = 0 },
  }
end

return M
