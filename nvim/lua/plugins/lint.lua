vim.pack.add({
  "https://github.com/mfussenegger/nvim-lint.git",
}, { confirm = false })

local lint = require("lint")

lint.linters_by_ft = {
  dockerfile = { "hadolint" },
  go = { "golangcilint" },
  php = { "phpcs" },
  markdown = { "markdownlint-cli2" },
}

local golangci_config_names = {
  ".golangci.yml",
  ".golangci.yaml",
  ".golangci.toml",
  ".golangci.json",
}

local function golangci_root(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  return vim.fs.root(filename, golangci_config_names)
end

local golangcilint = lint.linters.golangcilint
golangcilint.cmd = "mise"
golangcilint.args = vim.list_extend({ "exec", "--", "golangci-lint" }, golangcilint.args or {})

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

local lint_group = vim.api.nvim_create_augroup("my.lint", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = lint_group,
  pattern = "*.go",
  callback = function(args)
    local root = golangci_root(args.buf)
    if root then
      lint.try_lint("golangcilint", { cwd = root, ignore_errors = true })
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
  group = lint_group,
  callback = function(args)
    if vim.bo[args.buf].filetype ~= "go" then
      lint.try_lint(nil, { ignore_errors = true })
    end
  end,
})
