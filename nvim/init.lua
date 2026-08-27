require("config.options")
require("config.keymaps")
require("config.autocmds")
require('plugins.pr_comments')

-- ロード順が仕様:
--   theme が最初（ハイライトのちらつき防止）
--   lsp は先に常駐（診断・LspAttach を先に整える）
--   blink は InsertEnter/CmdlineEnter で遅延初期化
--   lang/* は lsp 設定の後に適用
local mods = {
  "plugins.theme",
  "plugins.treesitter",
  "plugins.ui",
  "plugins.navigation",
  "plugins.editor",
  "plugins.which-key",
  "plugins.yanky",
  "plugins.persistence",
  "plugins.rainbow-delmiters",
  "plugins.indent-blankline",
  "plugins.tmux",
  "plugins.vcs",
  "plugins.blink",
  "plugins.lsp",
  "plugins.conform",
  "plugins.lint",
  "plugins.lang.docker",
  "plugins.lang.go",
  "plugins.lang.json",
  "plugins.lang.lua",
  "plugins.lang.markdown",
  "plugins.lang.php",
  "plugins.lang.shell",
  "plugins.lang.tailwind",
  "plugins.lang.typescript",
  "plugins.lang.yaml",
}

for _, mod in ipairs(mods) do
  local ok, err = pcall(require, mod)
  if not ok then
    vim.notify(("Failed to load %s:\n%s"):format(mod, err), vim.log.levels.ERROR)
  end
end
