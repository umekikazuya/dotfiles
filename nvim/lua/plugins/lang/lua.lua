vim.lsp.config(
  "lua_ls",
  {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        runtime = { version = "LuaJIT" },
        telemetry = { enable = false },
        workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
      }
    }
  }
)
vim.lsp.enable("lua_ls")
