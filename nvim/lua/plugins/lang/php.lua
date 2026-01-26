return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "php" } },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "intelephense",
        "phpstan",
        "phpcbf",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {},
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
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
  },
  {
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
  },
}
