return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "dockerfile", "yaml" } },
    init = function()
      vim.filetype.add({
        pattern = {
          ["docker-compose.*%.yml"] = "yaml.docker-compose",
          ["docker-compose.*%.yaml"] = "yaml.docker-compose",
          ["compose.*%.yml"] = "yaml.docker-compose",
          ["compose.*%.yaml"] = "yaml.docker-compose",
        },
      })
    end,
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "dockerfile-language-server",
        "docker-compose-language-service",
        "hadolint",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dockerls = {},
        docker_compose_language_service = {},
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        dockerfile = { "hadolint" },
      },
    },
  },
}