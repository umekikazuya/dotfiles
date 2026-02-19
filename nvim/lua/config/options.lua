-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- 表示設定
vim.opt.list = true -- 不可視文字を表示モードにする
vim.opt.number = true -- 行番号表示
vim.opt.relativenumber = false -- 相対行番号を無効にする
vim.opt.laststatus = 2
vim.opt.cursorline = true
vim.opt.listchars = {
  -- タブの設定: "  " (スペース2つ) に設定することで、見た目を「透明」に変更
  tab = "  ",

  -- スペースの設定: "lead" を使って「行頭のインデント部分」だけ可視化
  lead = "·",

  -- 行末の余計なスペースは警告として表示
  trail = "·",
}

-- 文字・カーソル
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25-iCursor,r-cr-o:hor20"

-- エンコーディングとファイル設定
vim.opt.encoding = "utf-8"
vim.scriptencoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileformats = "unix,dos,mac"

-- 検索
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- その他
vim.opt.autowrite = true -- フォーカスが外れた時に自動保存

-- クリップボードをOSと共有する
vim.opt.clipboard = "unnamedplus"

-- LuaRocks (hererocks) のインストールエラー
vim.g.loaded_python3_provider = 0

-- Pythonパッケージの無効化
vim.g.loaded_python3_provider = 0

-- 行の折り返し（ラップ）の設定
-- false: 折り返さない（横スクロールする）, true: 画面端で折り返す
vim.opt.wrap = false

-- スクロール時の余白（カーソルが画面端に来る前に行をスクロールさせる）
vim.opt.scrolloff = 8
