local M = {}

local config_name = ".config/markdownlint-cli2/.markdownlint-cli2.jsonc"

function M.config_path(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  if filename == "" then
    return nil
  end

  return vim.fs.find(config_name, {
    path = vim.fs.dirname(filename),
    upward = true,
  })[1]
end

return M
