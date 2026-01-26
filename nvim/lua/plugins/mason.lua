return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- General / Formatting
        "stylua",
        "shfmt",

        -- SQL
        "sqlfluff",
      },
    },
  },
}
