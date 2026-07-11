local function set_keymap(mode, lhs, rhs, opts)
  local keymap_opts = vim.tbl_extend("force", { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, keymap_opts)
end

local function setup_diagnostic_keymaps()
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
end

local function setup_diagnostics()
  vim.diagnostic.config({
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    virtual_text = { spacing = 2, source = "if_many", prefix = "●" },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.HINT] = " ",
        [vim.diagnostic.severity.INFO] = " ",
      },
    },
  })
end

local function map_server_keys(bufnr, server_opts)
  if type(server_opts) ~= "table" or type(server_opts.keys) ~= "table" then
    return
  end

  for _, key in ipairs(server_opts.keys) do
    local lhs = key[1]
    local rhs = key[2]
    if type(lhs) == "string" and rhs ~= nil then
      set_keymap(key.mode or "n", lhs, rhs, {
        buffer = bufnr,
        desc = key.desc,
        expr = key.expr,
        nowait = key.nowait,
        remap = key.remap,
        silent = key.silent,
      })
    end
  end
end

local function setup_lsp_attach(servers)
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

      map("n", "grr", function()
        local ok, fzf = pcall(require, "fzf-lua")
        if ok then
          local opened = pcall(fzf.lsp_references)
          if opened then
            return
          end
        end
        vim.lsp.buf.references()
      end, "LSP References")
      map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
      map("n", "<leader>cl", "<cmd>LspInfo<cr>", "LSP Info")

      map_server_keys(bufnr, servers[client.name])

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
end

local function setup_capabilities()
  local ok, blink = pcall(require, "blink.cmp")
  if not ok then
    return
  end

  vim.lsp.config("*", {
    capabilities = blink.get_lsp_capabilities({
      workspace = {
        fileOperations = { didRename = true, willRename = true },
      },
    }),
  })
end

local function setup_servers(opts)
  local servers = opts.servers or {}
  local defaults = servers["*"] or {}

  for name, server_opts in pairs(servers) do
    if name ~= "*" and type(server_opts) == "table" and server_opts.enabled ~= false then
      local config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), vim.deepcopy(server_opts))
      config.mason = nil
      config.enabled = nil
      config.keys = nil
      vim.lsp.config(name, config)
      vim.lsp.enable(name)
    end
  end

  return servers
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    opts = {
      servers = {},
    },
    config = function(_, opts)
      setup_capabilities()
      local servers = setup_servers(opts or {})
      setup_diagnostics()
      setup_diagnostic_keymaps()
      setup_lsp_attach(servers)
    end,
  },
}