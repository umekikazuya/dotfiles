---@alias ConformCtx {buf: number, filename: string, dirname: string}
local M = {}

local supported = {
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

local config_names = {
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
function M.has_local_prettier(ctx)
  return vim.fs.find("node_modules/.bin/prettier", { path = ctx.dirname, upward = true })[1] ~= nil
end

---@param ctx ConformCtx
function M.has_config(ctx)
  return vim.fs.find(config_names, { path = ctx.dirname, upward = true })[1] ~= nil
end

---@param ctx ConformCtx
function M.has_parser(ctx)
  local ft = vim.bo[ctx.buf].filetype --[[@as string]]
  return vim.tbl_contains(supported, ft)
end

M.has_local_prettier = memoize(M.has_local_prettier)
M.has_config = memoize(M.has_config)
M.has_parser = memoize(M.has_parser)

return {
  {
    "stevearc/conform.nvim",
    optional = true,
    ---@param opts ConformOpts
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(supported) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], "prettier")
      end
      opts.formatters = opts.formatters or {}
      opts.formatters.prettier = {
        condition = function(_, ctx)
          return M.has_local_prettier(ctx) and M.has_config(ctx) and M.has_parser(ctx)
        end,
      }
    end,
  },
}