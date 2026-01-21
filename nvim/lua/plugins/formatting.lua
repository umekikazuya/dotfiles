return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    -- プロジェクト毎の環境変数にてサービス名を設定する
    local service = os.getenv("NVIM_PHP_DOCKER_SERVICE") or "app"

    opts.default_format_opts = opts.default_format_opts or {}
    opts.default_format_opts.timeout_ms = 30000

    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.formatters_by_ft.php = { "phpcbf" }

    opts.formatters = opts.formatters or {}
    opts.formatters.phpcbf = {
      command = "docker",
      args = {
        "compose",
        "exec",
        "-T",
        service,
        "php",
        "vendor/bin/phpcbf",
        "-",
      },
      stdin = true,
    }

    return opts
  end,
}
