-- pr_comments.lua
--
-- 使い方:
--   require('pr_comments')   -- 1回読み込むだけで :PrComments コマンドが使えるようになる
--
--   :PrComments        現在のブランチに紐づくPRの「未解決」レビューコメントを一覧
--   :PrComments!       解決済みも含めて全部一覧
--   :PrComments 123    PR番号を明示指定
--
-- quickfixウィンドウ内:
--   <CR>   通常のquickfix動作でその行にジャンプ
--   K      カーソル行のスレッドの全文(元コメント+返信すべて)をフロートで表示。q/<Esc>で閉じる
--   rr     カーソル行のスレッドをGitHub上でresolveし、一覧からも消す
--   go     カーソル行のコメントをブラウザで開く

local M = {}

local QUERY = [[
query($owner: String!, $repo: String!, $pr: Int!, $endCursor: String) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $pr) {
      reviewThreads(first: 50, after: $endCursor) {
        pageInfo { hasNextPage endCursor }
        nodes {
          id
          isResolved
          isOutdated
          path
          line
          originalLine
          comments(first: 20) {
            nodes {
              author { login }
              body
              createdAt
              url
            }
          }
        }
      }
    }
  }
}
]]

local RESOLVE_MUTATION = [[
mutation($id: ID!) {
  resolveReviewThread(input: { threadId: $id }) {
    thread { id isResolved }
  }
}
]]

local function notify_err(msg)
  vim.notify(msg, vim.log.levels.ERROR)
end

local function get_repo_owner_and_name()
  local out = vim.fn.system({ 'gh', 'repo', 'view', '--json', 'nameWithOwner', '-q', '.nameWithOwner' })
  if vim.v.shell_error ~= 0 then
    return nil, nil, vim.trim(out)
  end
  local nwo = vim.trim(out)
  local owner, repo = nwo:match('^(.-)/(.+)$')
  return owner, repo
end

local function get_current_pr_number()
  local out = vim.fn.system({ 'gh', 'pr', 'view', '--json', 'number', '-q', '.number' })
  if vim.v.shell_error ~= 0 then
    return nil, vim.trim(out)
  end
  return tonumber(vim.trim(out))
end

local function get_git_root()
  local out = vim.fn.system({ 'git', 'rev-parse', '--show-toplevel' })
  if vim.v.shell_error ~= 0 then
    return vim.fn.getcwd()
  end
  return vim.trim(out)
end

local function shrink(text, maxlen)
  text = text:gsub('\r', ''):gsub('\n', ' ')
  text = vim.trim(text)
  if #text > maxlen then
    text = text:sub(1, maxlen) .. '...'
  end
  return text
end

local function fetch_threads(owner, repo, pr)
  local threads = {}
  local cursor = nil
  while true do
    local args = {
      'gh', 'api', 'graphql',
      '-f', 'query=' .. QUERY,
      '-F', 'owner=' .. owner,
      '-F', 'repo=' .. repo,
      '-F', 'pr=' .. pr,
    }
    if cursor then
      table.insert(args, '-F')
      table.insert(args, 'endCursor=' .. cursor)
    end
    local out = vim.fn.system(args)
    if vim.v.shell_error ~= 0 then
      return nil, out
    end
    local ok, decoded = pcall(vim.json.decode, out)
    if not ok then
      return nil, 'JSON decode error: ' .. tostring(decoded)
    end
    if decoded.errors then
      return nil, vim.inspect(decoded.errors)
    end
    local rt = decoded.data.repository.pullRequest.reviewThreads
    for _, node in ipairs(rt.nodes) do
      table.insert(threads, node)
    end
    if rt.pageInfo.hasNextPage then
      cursor = rt.pageInfo.endCursor
    else
      break
    end
  end
  return threads
end

function M.show(opts)
  opts = opts or {}

  local owner, repo, rerr = get_repo_owner_and_name()
  if not owner then
    notify_err('リポジトリ情報の取得に失敗しました: ' .. (rerr or ''))
    return
  end

  local pr = opts.pr
  if not pr then
    local perr
    pr, perr = get_current_pr_number()
    if not pr then
      notify_err('現在のブランチに紐づくPRが見つかりません。:PrComments <番号> で指定してください。 ' .. (perr or ''))
      return
    end
  end

  local threads, ferr = fetch_threads(owner, repo, pr)
  if not threads then
    notify_err('レビューコメントの取得に失敗しました: ' .. tostring(ferr))
    return
  end

  local root = get_git_root()
  local items = {}
  for _, t in ipairs(threads) do
    if opts.all or not t.isResolved then
      local comments = t.comments.nodes
      if comments and #comments > 0 then
        local first = comments[1]
        local reply_note = #comments > 1 and (' (+' .. (#comments - 1) .. '件の返信)') or ''
        local status
        if t.isResolved then
          status = '[解決済]'
        elseif t.isOutdated then
          status = '[未解決/古い差分]'
        else
          status = '[未解決]'
        end
        local author = (first.author and first.author.login) or '不明'
        local text = string.format('%s @%s%s: %s', status, author, reply_note, shrink(first.body or '', 90))
        local lnum = t.line or t.originalLine or 1

        local full_comments = {}
        for _, c in ipairs(comments) do
          table.insert(full_comments, {
            author = (c.author and c.author.login) or '不明',
            body = c.body or '',
            created_at = c.createdAt,
          })
        end

        table.insert(items, {
          filename = root .. '/' .. t.path,
          lnum = lnum,
          text = text,
          user_data = {
            thread_id = t.id,
            url = first.url,
            path = t.path,
            status = status,
            comments = full_comments,
          },
        })
      end
    end
  end

  table.sort(items, function(a, b)
    if a.filename == b.filename then
      return a.lnum < b.lnum
    end
    return a.filename < b.filename
  end)

  if #items == 0 then
    vim.notify('対象のレビューコメントはありません(全部解決済みかも。:PrComments! で解決済みも表示できます)', vim.log.levels.INFO)
    return
  end

  vim.fn.setqflist({}, ' ', {
    title = string.format('PR #%d review comments (%d)', pr, #items),
    items = items,
  })
  vim.cmd('copen 15')
end

local function qf_item_under_cursor()
  if vim.bo.filetype ~= 'qf' then
    vim.notify('quickfixウィンドウの中で実行してください', vim.log.levels.WARN)
    return nil, nil
  end
  local idx = vim.fn.line('.')
  local items = vim.fn.getqflist()
  return items[idx], idx
end

function M.resolve_under_cursor()
  local item, idx = qf_item_under_cursor()
  if not item then
    return
  end
  if not item.user_data or not item.user_data.thread_id then
    vim.notify('このエントリにはスレッド情報がありません', vim.log.levels.WARN)
    return
  end

  local out = vim.fn.system({
    'gh', 'api', 'graphql',
    '-f', 'query=' .. RESOLVE_MUTATION,
    '-F', 'id=' .. item.user_data.thread_id,
  })
  if vim.v.shell_error ~= 0 then
    notify_err('resolveに失敗しました: ' .. out)
    return
  end

  local items = vim.fn.getqflist()
  table.remove(items, idx)
  vim.fn.setqflist({}, 'r', { items = items })
  vim.notify('スレッドをresolveしました', vim.log.levels.INFO)
end

function M.open_under_cursor()
  local item = qf_item_under_cursor()
  if not item then
    return
  end
  if not item.user_data or not item.user_data.url then
    vim.notify('このエントリにはURLがありません', vim.log.levels.WARN)
    return
  end
  if vim.ui and vim.ui.open then
    vim.ui.open(item.user_data.url)
  else
    vim.fn.system({ 'gh', 'browse', item.user_data.url })
  end
end

function M.preview_under_cursor()
  local item = qf_item_under_cursor()
  if not item then
    return
  end
  if not item.user_data or not item.user_data.comments then
    vim.notify('このエントリには本文情報がありません', vim.log.levels.WARN)
    return
  end

  local lines = {}
  table.insert(lines, string.format('# %s:%d %s', item.user_data.path or '', item.lnum, item.user_data.status or ''))
  table.insert(lines, '')
  for _, c in ipairs(item.user_data.comments) do
    table.insert(lines, string.format('## @%s  (%s)', c.author, c.created_at or ''))
    table.insert(lines, '')
    for _, l in ipairs(vim.split(c.body, '\n', { plain = true })) do
      table.insert(lines, l)
    end
    table.insert(lines, '')
    table.insert(lines, '---')
    table.insert(lines, '')
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = 'markdown'
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = 'wipe'

  local width = math.min(100, vim.o.columns - 4)
  local height = math.min(24, vim.o.lines - 6)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = 'minimal',
    border = 'rounded',
    title = ' PR comment thread ',
    title_pos = 'center',
  })
  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true
  vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = buf, nowait = true })
  vim.keymap.set('n', '<Esc>', '<cmd>close<CR>', { buffer = buf, nowait = true })
end

vim.api.nvim_create_user_command('PrComments', function(cmd_opts)
  local pr = tonumber(cmd_opts.args)
  M.show({ pr = (pr and pr ~= 0) and pr or nil, all = cmd_opts.bang })
end, { nargs = '?', bang = true, desc = 'PRのレビューコメントをquickfixに一覧表示' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function(args)
    vim.wo.wrap = true
    vim.wo.linebreak = true
    vim.keymap.set('n', 'rr', M.resolve_under_cursor, { buffer = args.buf, desc = 'PRレビュースレッドをresolve' })
    vim.keymap.set('n', 'go', M.open_under_cursor, { buffer = args.buf, desc = 'PRレビューコメントをブラウザで開く' })
    vim.keymap.set('n', 'K', M.preview_under_cursor, { buffer = args.buf, desc = 'PRレビュースレッドの全文をプレビュー' })
  end,
})

return M