-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

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

-- 行の折り返し（ラップ）の設定
-- false: 折り返さない（横スクロールする）, true: 画面端で折り返す
vim.opt.wrap = false

-- スクロール時の余白（カーソルが画面端に来る前に行をスクロールさせる）
vim.opt.scrolloff = 8
