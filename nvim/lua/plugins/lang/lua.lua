vim.lsp.config(
  "lua_ls",
  {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        runtime = { version = "LuaJIT" },
        telemetry = { enable = false },
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME .. "/lua",
            vim.fn.stdpath("config") .. "/lua",
          },
          maxPreload = 1000,
          preloadFileSize = 1000,
        },
      }
    }
  }
)
vim.lsp.enable("lua_ls")
