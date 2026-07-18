vim.pack.add({
  "https://github.com/mfussenegger/nvim-lint.git",
}, { confirm = false })

local lint = require("lint")

lint.linters_by_ft = {
  dockerfile = { "hadolint" },
  php = { "phpcs" },
  markdown = { "markdownlint-cli2" },
}

-- phpcs は docker compose 経由で実行（組み込み定義の parser を保つため部分上書きに留める）
local service = os.getenv("NVIM_PHP_DOCKER_SERVICE") or "app"
local phpcs = lint.linters.phpcs
phpcs.cmd = "docker"
phpcs.args = {
  "compose",
  "exec",
  "-T",
  service,
  "php",
  "vendor/bin/phpcs",
  "--report=json",
  "-",
}
phpcs.stdin = true

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("my.lint", { clear = true }),
  callback = function()
    require("lint").try_lint(nil, { ignore_errors = true })
  end,
})
