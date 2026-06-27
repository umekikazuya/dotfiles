---@alias ConformCtx {buf: number, filename: string, dirname: string}

local supported = {
  "css",
  "graphql",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "typescript",
  "typescriptreact",
}

local function has_biome_config(ctx)
  return vim.fs.find("biome.json", { path = ctx.dirname, upward = true })[1] ~= nil
end

return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(supported) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], 1, "biome")
      end
      opts.formatters = opts.formatters or {}
      opts.formatters.biome = {
        condition = function(_, ctx)
          return has_biome_config(ctx)
        end,
      }
    end,
  },
}
