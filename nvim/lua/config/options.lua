-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- 不可視文字を表示モードにする
vim.opt.list = true

vim.opt.listchars = {
  -- タブの設定: "  " (スペース2つ) に設定することで、見た目を「透明」に変更
  tab = "  ",

  -- スペースの設定: "lead" を使って「行頭のインデント部分」だけ可視化
  lead = "·",

  -- 行末の余計なスペースは警告として表示
  trail = "·",
}

-- フォーカスが外れた時に自動保存
vim.opt.autowrite = true

-- クリップボードをOSと共有する
vim.opt.clipboard = "unnamedplus"

-- 検索時に大文字小文字を区別しない
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- 行番号を表示する
vim.opt.number = true

-- 相対行番号を無効にする
vim.opt.relativenumber = false

-- インデントの設定（デフォルトは2スペース）
-- vim.opt.tabstop = 4
-- vim.opt.shiftwidth = 4

-- LuaRocks (hererocks) のインストールエラー
vim.g.loaded_python3_provider = 0

-- Pythonパッケージの無効化
vim.g.loaded_python3_provider = 0

-- 行の折り返し（ラップ）の設定
-- false: 折り返さない（横スクロールする）, true: 画面端で折り返す
vim.opt.wrap = false

-- スクロール時の余白（カーソルが画面端に来る前に行をスクロールさせる）
vim.opt.scrolloff = 8