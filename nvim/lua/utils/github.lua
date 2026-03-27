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
  for _, node in ipairs(nodes) do
    table.insert(items, {
      text = node.title, -- 検索・表示用タイトル
      body = node.body:gsub("\r\n", "\n"), -- 本文
    })
  end

  -- 2. Snacks.picker を起動
  Snacks.picker({
    source = "github_saved_replies",
    items = items,
    layout = "select",
    -- format を指定して、何を表示するか明示する
    format = function(item)
      return { { item.text, "SnacksLabel" } }
    end,
    confirm = function(picker, item)
      picker:close()
      if item then
        vim.schedule(function()
          local lines = vim.split(item.body, "\n")
          -- 'l' は行全体、'c' は文字単位。
          vim.api.nvim_put(lines, "c", true, true)
        end)
      end
    end,
  })
end

return M
