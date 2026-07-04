-- lua/utils/github.lua
local M = {}

function M.insert_saved_reply()
  -- 1. コマンドを実行して出力を受け取る
  local cmd = "gh api graphql -f query='query { viewer { savedReplies(first: 50) { nodes { title body } } } }'"
  local handle = io.popen(cmd)
  local result = handle:read("*a")
  handle:close()

  local data = vim.fn.json_decode(result)
  local nodes = data.data.viewer.savedReplies.nodes

  if #nodes == 0 then
    print("Saved Replies が空っぽです。")
    return
  end

  local items = {}
  local entries = {}
  for _, node in ipairs(nodes) do
    table.insert(items, {
      text = node.title, -- 検索・表示用タイトル
      body = node.body:gsub("\r\n", "\n"), -- 本文
    })
  end

  for i, item in ipairs(items) do
    entries[i] = string.format("%03d\t%s", i, item.text)
  end

  -- 2. fzf-lua を起動
  require("fzf-lua").fzf_exec(entries, {
    prompt = "Saved Replies> ",
    actions = {
      ["default"] = function(selected)
        local choice = selected and selected[1]
        if not choice then
          return
        end
        local idx = tonumber(choice:match("^(%d+)\t"))
        local item = idx and items[idx] or nil
        if item then
          vim.schedule(function()
            local lines = vim.split(item.body, "\n")
            -- 'l' は行全体、'c' は文字単位。
            vim.api.nvim_put(lines, "c", true, true)
          end)
        end
      end,
    },
  })
end

return M
