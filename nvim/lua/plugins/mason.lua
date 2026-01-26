return {
  {
    "mason-org/mason.nvim",
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
        "intelephense",
        "phpstan",
        "phpcbf",
        -- Twig
        "twigcs",
        "twig-cs-fixer",
      },
    },
  },
}