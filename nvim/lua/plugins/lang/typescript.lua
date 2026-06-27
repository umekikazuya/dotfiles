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
            {
              "gd",
              function()
                local params = vim.lsp.util.make_position_params()
                vim.lsp.buf_request(0, "workspace/executeCommand", {
                  command = "typescript.goToSourceDefinition",
                  arguments = { params.textDocument.uri, params.position },
                }, function(err, result)
                  if err or not result or vim.tbl_isempty(result) then
                    vim.lsp.buf.definition()
                  else
                    vim.lsp.util.jump_to_location(result[1], "utf-8")
                  end
                end)
              end,
              desc = "Goto Definition",
            },
            { "<leader>cM", LazyVim.lsp.action["source.addMissingImports.ts"], desc = "Add Missing Imports" },
            { "<leader>cD", LazyVim.lsp.action["source.fixAll.ts"], desc = "Fix All Diagnostics" },
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
