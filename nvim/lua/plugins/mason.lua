return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- General / Formatting
        "stylua",
        "shfmt",
      })

      local seen = {}
      opts.ensure_installed = vim.tbl_filter(function(pkg)
        if seen[pkg] then
          return false
        end
        seen[pkg] = true
        return true
      end, opts.ensure_installed)
    end,
  },
}
