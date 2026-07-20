vim.pack.add({
  "https://github.com/stevearc/conform.nvim.git",
}, { confirm = false })

---@alias ConformCtx {buf: number, filename: string, dirname: string}

-- biome: プロジェクトに biome.json があるときだけ有効
local function has_biome_config(ctx)
  return vim.fs.find("biome.json", { path = ctx.dirname, upward = true })[1] ~= nil
end

-- prettier: ローカル prettier + 設定ファイル + 対応 parser が揃うときだけ有効
local prettier_fts = {
  "css",
  "graphql",
  "handlebars",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "less",
  "markdown",
  "markdown.mdx",
  "scss",
  "typescript",
  "typescriptreact",
  "vue",
  "yaml",
}

local prettier_config_names = {
  ".prettierrc",
  ".prettierrc.json",
  ".prettierrc.json5",
  ".prettierrc.yml",
  ".prettierrc.yaml",
  ".prettierrc.js",
  ".prettierrc.cjs",
  ".prettierrc.mjs",
  ".prettierrc.toml",
  "prettier.config.js",
  "prettier.config.cjs",
  "prettier.config.mjs",
  "prettier.config.ts",
  "prettier.config.cts",
  "prettier.config.mts",
}

local function memoize(fn)
  local cache = {}
  return function(ctx)
    local key = ctx.filename
    if cache[key] == nil then
      cache[key] = fn(ctx)
    end
    return cache[key]
  end
end

---@param ctx ConformCtx
local has_local_prettier = memoize(function(ctx)
  return vim.fs.find("node_modules/.bin/prettier", { path = ctx.dirname, upward = true })[1] ~= nil
end)

---@param ctx ConformCtx
local has_prettier_config = memoize(function(ctx)
  return vim.fs.find(prettier_config_names, { path = ctx.dirname, upward = true })[1] ~= nil
end)

---@param ctx ConformCtx
local has_prettier_parser = memoize(function(ctx)
  local ft = vim.bo[ctx.buf].filetype --[[@as string]]
  return vim.tbl_contains(prettier_fts, ft)
end)

local php_service = os.getenv("NVIM_PHP_DOCKER_SERVICE") or "app"

require("conform").setup({
  -- 旧 pack.lua が注入していたデフォルトを明示
  format_on_save = function(bufnr)
    if vim.b[bufnr].autosave_in_progress then
      return nil
    end

    return {
      timeout_ms = 3000,
      lsp_format = "fallback",
    }
  end,
  default_format_opts = {
    timeout_ms = 30000,
  },
  formatters_by_ft = {
    -- biome 対応 ft は biome 優先、prettier フォールバック（各 condition で絞る）
    css = { "biome", "prettier" },
    graphql = { "biome", "prettier" },
    javascript = { "biome", "prettier" },
    javascriptreact = { "biome", "prettier" },
    json = { "biome", "prettier" },
    jsonc = { "biome", "prettier" },
    typescript = { "biome", "prettier" },
    typescriptreact = { "biome", "prettier" },

    handlebars = { "prettier" },
    html = { "prettier" },
    less = { "prettier" },
    scss = { "prettier" },
    vue = { "prettier" },
    yaml = { "prettier" },

    go = { "goimports", "gofumpt" },
    php = { "phpcbf" },
    markdown = { "prettier", "markdownlint-cli2", "markdown-toc" },
    ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
  },
  formatters = {
    biome = {
      condition = function(_, ctx)
        return has_biome_config(ctx)
      end,
    },
    prettier = {
      condition = function(_, ctx)
        return has_local_prettier(ctx) and has_prettier_config(ctx) and has_prettier_parser(ctx)
      end,
    },
    ["markdown-toc"] = {
      condition = function(_, ctx)
        for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
          if line:find("<!%-%- toc %-%->") then
            return true
          end
        end
      end,
    },
    ["markdownlint-cli2"] = {
      condition = function(_, ctx)
        local diag = vim.tbl_filter(function(d)
          return d.source == "markdownlint"
        end, vim.diagnostic.get(ctx.buf))
        return #diag > 0
      end,
    },
    phpcbf = {
      command = "docker",
      args = {
        "compose",
        "exec",
        "-T",
        php_service,
        "php",
        "vendor/bin/phpcbf",
        "-",
      },
      stdin = true,
    },
  },
})
