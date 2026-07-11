local lang_settings = {
  updateImportsOnFileMove = { enabled = "always" },
  suggest = { completeFunctionCalls = true },
  inlayHints = {
    parameterNames = { enabled = "literals" },
    parameterTypes = { enabled = true },
    variableTypes = { enabled = false },
    functionLikeReturnTypes = { enabled = true },
    enumMemberValues = { enabled = true },
    propertyDeclarationTypes = { enabled = true },
  },
}

local function apply_ts_code_action(action_kind)
  return function()
    vim.lsp.buf.code_action({
      apply = true,
      context = {
        only = { action_kind },
        diagnostics = {},
      },
    })
  end
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "typescript", "tsx", "javascript" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          mason = false,
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          },
          keys = {
            { "<leader>cM", apply_ts_code_action("source.addMissingImports.ts"), desc = "Add Missing Imports" },
            { "<leader>cD", apply_ts_code_action("source.fixAll.ts"), desc = "Fix All Diagnostics" },
          },
          settings = {
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = { enableServerSideFuzzyMatch = true },
              },
            },
            typescript = lang_settings,
            javascript = lang_settings,
          },
        },
      },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
