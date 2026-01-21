return {
  "mfussenegger/nvim-lint",
  opts = function(_, opts)
    local service = os.getenv("NVIM_PHP_DOCKER_SERVICE") or "app"

    opts.linters_by_ft = opts.linters_by_ft or {}
    opts.linters_by_ft.php = { "phpcs" }

    opts.linters = opts.linters or {}
    opts.linters.phpcs = {
      cmd = "docker",
      args = {
        "compose",
        "exec",
        "-T",
        service,
        "php",
        "vendor/bin/phpcs",
        "--report=json",
        "-",
      },
      stdin = true,
    }

    return opts
  end,
}
