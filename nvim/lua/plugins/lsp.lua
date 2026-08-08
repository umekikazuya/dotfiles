vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig.git",
}, { confirm = false })

local function set_keymap(mode, lhs, rhs, opts)
  local keymap_opts = vim.tbl_extend("force", { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, keymap_opts)
end

-- capabilities（blink.lua はこのファイルより先にロードされる）
local ok, blink = pcall(require, "blink.cmp")
if ok then
  vim.lsp.config("*", {
    capabilities = blink.get_lsp_capabilities({
      workspace = {
        fileOperations = { didRename = true, willRename = true },
      },
    }),
  })
end

vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  virtual_text = { spacing = 2, source = "if_many", prefix = "●" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN] = "W",
      [vim.diagnostic.severity.HINT] = "H",
      [vim.diagnostic.severity.INFO] = "I",
    },
  },
})

set_keymap("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous Diagnostic" })
set_keymap("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next Diagnostic" })
set_keymap("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
set_keymap("n", "<leader>xl", function()
  vim.diagnostic.setloclist({ open = true })
end, { desc = "Diagnostics to Location List" })
set_keymap("n", "<leader>xq", function()
  vim.diagnostic.setqflist({ open = true })
end, { desc = "Diagnostics to Quickfix List" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    local function map(mode, lhs, rhs, desc)
      set_keymap(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end
    local function ensure_default_map(mode, lhs, rhs, desc)
      local existing = vim.fn.maparg(lhs, mode, false, true)
      if type(existing) == "table" and next(existing) ~= nil then
        return
      end
      map(mode, lhs, rhs, desc)
    end

    map("n", "grr", function()
      local fzf_ok, fzf = pcall(require, "fzf-lua")
      if fzf_ok then
        local opened = pcall(fzf.lsp_references)
        if opened then
          return
        end
      end
      vim.lsp.buf.references()
    end, "LSP References")
    ensure_default_map("n", "gd", function()
      vim.lsp.buf.definition({ reuse_win = true })
    end, "Goto Definition")
    map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
    map("n", "<leader>cl", "<cmd>LspInfo<cr>", "LSP Info")

    if client:supports_method("textDocument/codeLens") then
      map("n", "<leader>cc", vim.lsp.codelens.run, "Run Codelens")
      map("x", "<leader>cc", vim.lsp.codelens.run, "Run Codelens")
      map("n", "<leader>cC", vim.lsp.codelens.refresh, "Refresh Codelens")
    end

    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    if client:supports_method("textDocument/foldingRange") then
      local win = vim.api.nvim_get_current_win()
      if vim.wo[win].foldmethod == "manual" then
        vim.wo[win].foldmethod = "expr"
        vim.wo[win].foldexpr = "v:lua.vim.lsp.foldexpr()"
      end
      vim.wo[win].foldlevel = 99
      vim.o.foldlevelstart = 99
    end
  end,
})
