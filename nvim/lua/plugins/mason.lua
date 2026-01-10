return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- General / Formatting
        "stylua",
        "shfmt",

        -- Markdown
        "markdown-toc",

        -- SQL
        "sqlfluff",

        -- PHP
        "phpactor",
        "php-cs-fixer",
        "phpcbf",
        "phpcs",

        -- Go
        "gofumpt",
      },
    },
  },
}
