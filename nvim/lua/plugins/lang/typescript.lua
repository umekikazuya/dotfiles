vim.pack.add({
  "https://github.com/windwp/nvim-ts-autotag.git",
  "https://github.com/folke/ts-comments.nvim.git",
}, { confirm = false })

require("nvim-ts-autotag").setup({})
require("ts-comments").setup({})

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

vim.lsp.config("vtsls", {
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
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
})
vim.lsp.enable("vtsls")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my.lsp.vtsls_keys", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "vtsls" then
      return
    end
    vim.keymap.set("n", "<leader>cM", apply_ts_code_action("source.addMissingImports.ts"), {
      buffer = args.buf,
      silent = true,
      desc = "Add Missing Imports",
    })
    vim.keymap.set("n", "<leader>cD", apply_ts_code_action("source.fixAll.ts"), {
      buffer = args.buf,
      silent = true,
      desc = "Fix All Diagnostics",
    })
  end,
})
