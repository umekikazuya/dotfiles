return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "gr", false },
          },
        },
      },
    },
  },
}
-- return {
--   { "mason-org/mason-lspconfig.nvim", enabled = false },
--
--   {
--     "neovim/nvim-lspconfig",
--     event = { "BufReadPre", "BufNewFile" },
--     dependencies = { "saghen/blink.cmp" },
--     opts = { servers = {} },
--     config = function(_, opts)
--       vim.lsp.config("*", {
--         capabilities = require("blink.cmp").get_lsp_capabilities({
--           workspace = {
--             fileOperations = { didRename = true, willRename = true },
--           },
--         }),
--       })
--
--       for name, server_opts in pairs(opts.servers or {}) do
--         if name == "*" or type(server_opts) ~= "table" or server_opts.enabled == false then
--           goto continue
--         end
--         local config = vim.tbl_deep_extend("force", {}, server_opts)
--         config.mason = nil
--         config.enabled = nil
--         config.keys = nil
--         vim.lsp.config(name, config)
--         vim.lsp.enable(name)
--         ::continue::
--       end
--
--       vim.api.nvim_create_autocmd("LspAttach", {
--         callback = function(args)
--           local buf = args.buf
--           local client = vim.lsp.get_client_by_id(args.data.client_id)
--           if not client then
--             return
--           end
--
--           local function map(lhs, rhs, desc, mode)
--             vim.keymap.set(mode or "n", lhs, rhs, { buffer = buf, desc = desc })
--           end
--
--           -- 情報
--           map("gK", vim.lsp.buf.signature_help, "Signature Help")
--           map("<c-k>", vim.lsp.buf.signature_help, "Signature Help", "i")
--           map("<leader>cl", function()
--             Snacks.picker.lsp_config()
--           end, "Lsp Info")
--           map("<leader>ss", function()
--             Snacks.picker.lsp_symbols()
--           end, "LSP Symbols")
--           map("<leader>sS", function()
--             Snacks.picker.lsp_workspace_symbols()
--           end, "LSP Workspace Symbols")
--
--           -- 操作
--           map("<leader>cr", vim.lsp.buf.rename, "Rename")
--           map("<leader>cR", function()
--             Snacks.rename.rename_file()
--           end, "Rename File")
--           map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
--           map("<leader>ca", vim.lsp.buf.code_action, "Code Action", "x")
--           map("<leader>cA", function()
--             vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } })
--           end, "Source Action")
--           map("<leader>co", function()
--             vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } } })
--           end, "Organize Imports")
--
--           -- codelens（対応サーバーのみ）
--           if client:supports_method("textDocument/codeLens") then
--             map("<leader>cc", vim.lsp.codelens.run, "Run Codelens")
--             map("<leader>cc", vim.lsp.codelens.run, "Run Codelens", "x")
--             map("<leader>cC", vim.lsp.codelens.refresh, "Refresh Codelens")
--           end
--
--           -- 同じ単語の参照ジャンプ（対応サーバーのみ）
--           if client:supports_method("textDocument/documentHighlight") and Snacks.words.is_enabled() then
--             map("]]", function()
--               Snacks.words.jump(vim.v.count1)
--             end, "Next Reference")
--             map("[[", function()
--               Snacks.words.jump(-vim.v.count1)
--             end, "Prev Reference")
--             map("<a-n>", function()
--               Snacks.words.jump(vim.v.count1, true)
--             end, "Next Reference")
--             map("<a-p>", function()
--               Snacks.words.jump(-vim.v.count1, true)
--             end, "Prev Reference")
--           end
--
--           -- inlay hints
--           if client:supports_method("textDocument/inlayHint") then
--             vim.lsp.inlay_hint.enable(true, { bufnr = buf })
--           end
--
--           -- LSP folding（za で開閉できるようになる）
--           if client:supports_method("textDocument/foldingRange") then
--             local win = vim.api.nvim_get_current_win()
--             if vim.wo[win].foldmethod == "manual" then
--               vim.wo[win].foldmethod = "expr"
--               vim.wo[win].foldexpr = "v:lua.vim.lsp.foldexpr()"
--             end
--           end
--         end,
--       })
--
--       vim.diagnostic.config({
--         underline = true,
--         update_in_insert = false,
--         virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
--         severity_sort = true,
--         signs = {
--           text = {
--             [vim.diagnostic.severity.ERROR] = " ",
--             [vim.diagnostic.severity.WARN] = " ",
--             [vim.diagnostic.severity.HINT] = " ",
--             [vim.diagnostic.severity.INFO] = " ",
--           },
--         },
--       })
--     end,
--   },
-- }
