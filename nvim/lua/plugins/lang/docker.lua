return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "dockerfile", "yaml" } },
    init = function()
      vim.filetype.add({
        pattern = {
          ["docker%-compose.*%.yml"] = "yaml.docker-compose",
          ["docker%-compose.*%.yaml"] = "yaml.docker-compose",
          ["compose.*%.yml"] = "yaml.docker-compose",
          ["compose.*%.yaml"] = "yaml.docker-compose",
        },
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        docker_language_server = {},
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