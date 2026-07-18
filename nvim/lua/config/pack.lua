local M = {}

local function module_name_from_path(path)
  local config = vim.fs.normalize(vim.fn.stdpath("config"))
  local lua_root = config .. "/lua/"
  local rel = path:sub(#lua_root + 1)
  rel = rel:gsub("%.lua$", "")
  return rel:gsub("/", ".")
end

local function list_plugin_modules()
  local paths = {}
  local patterns = {
    vim.fn.stdpath("config") .. "/lua/plugins/*.lua",
    vim.fn.stdpath("config") .. "/lua/plugins/lang/*.lua",
  }

  for _, pattern in ipairs(patterns) do
    for _, path in ipairs(vim.fn.glob(pattern, true, true)) do
      paths[#paths + 1] = path
    end
  end

  table.sort(paths)

  local modules = {}
  for _, path in ipairs(paths) do
    modules[#modules + 1] = module_name_from_path(path)
  end
  return modules
end

local function normalize_top_level_specs(value)
  if type(value) ~= "table" then
    return {}
  end
  if type(value[1]) == "string" then
    return { value }
  end
  return value
end

local function normalize_spec(spec)
  if type(spec) == "string" then
    return { spec }
  end
  return spec
end

local function is_enabled(spec)
  if spec.enabled == false then
    return false
  end
  if type(spec.enabled) == "function" then
    local ok, ret = pcall(spec.enabled)
    if not ok or ret == false then
      return false
    end
  end
  if spec.cond == false then
    return false
  end
  if type(spec.cond) == "function" then
    local ok, ret = pcall(spec.cond)
    if not ok or ret == false then
      return false
    end
  end
  return true
end

local function deep_merge_lists(left, right)
  if type(left) ~= "table" then
    return vim.deepcopy(right)
  end
  if type(right) ~= "table" then
    return right
  end

  if vim.islist(left) and vim.islist(right) then
    local merged = vim.deepcopy(left)
    vim.list_extend(merged, vim.deepcopy(right))
    return merged
  end

  local merged = vim.deepcopy(left)
  for key, value in pairs(right) do
    if type(merged[key]) == "table" and type(value) == "table" then
      merged[key] = deep_merge_lists(merged[key], value)
    else
      merged[key] = vim.deepcopy(value)
    end
  end
  return merged
end

local function resolve_source(repo)
  if repo:find("://") or repo:match("^git@") then
    return repo
  end
  if repo:match("^[%w_.-]+/[%w_.-]+$") then
    return ("https://github.com/%s.git"):format(repo)
  end
  return repo
end

local function plugin_name(spec)
  local repo = spec[1] or spec.src
  if type(repo) ~= "string" or repo == "" then
    return nil
  end
  if spec.name and spec.name ~= "" then
    return spec.name
  end
  local clean = repo:gsub("%.git$", "")
  return clean:match("([^/]+)$")
end

local function call_build(spec)
  local build = spec.build
  if type(build) == "function" then
    pcall(build, spec)
  elseif type(build) == "string" and build ~= "" then
    vim.fn.system(build)
  end
end

local function pack_name_for(spec_name, explicit_name)
  if type(explicit_name) == "string" and explicit_name ~= "" then
    return explicit_name
  end
  return spec_name
end

local setup_modules = {
  ["blink.cmp"] = "blink.cmp",
  ["conform.nvim"] = "conform",
  ["fidget.nvim"] = "fidget",
  ["flash.nvim"] = "flash",
  ["gitlinker.nvim"] = "gitlinker",
  ["gitsigns.nvim"] = "gitsigns",
  ["lualine.nvim"] = "lualine",
  ["mini.ai"] = "mini.ai",
  ["mini.pairs"] = "mini.pairs",
  ["mini.icons"] = "mini.icons",
  ["mini.surround"] = "mini.surround",
  ["nvim-lint"] = "lint",
  ["nvim-ts-autotag"] = "nvim-ts-autotag",
  ["oil.nvim"] = "oil",
  ["render-markdown.nvim"] = "render-markdown",
  ["ts-comments.nvim"] = "ts-comments",
  ["trouble.nvim"] = "trouble",
  ["treesj"] = "treesj",
}

local function apply_lsp(opts)
  if type(opts) ~= "table" then
    return
  end

  local servers = opts.servers or {}
  for name, server_opts in pairs(servers) do
    if name ~= "*" and type(server_opts) == "table" and server_opts.enabled ~= false then
      local config = vim.deepcopy(server_opts)
      config.enabled = nil
      config.keys = nil
      vim.lsp.config(name, config)
      vim.lsp.enable(name)
    end
  end
end

local function apply_keys(keys)
  if type(keys) ~= "table" then
    return
  end

  for _, map in ipairs(keys) do
    local lhs = map[1]
    local rhs = map[2]
    if type(lhs) == "string" and rhs ~= nil then
      local opts = {
        desc = map.desc,
        expr = map.expr,
        nowait = map.nowait,
        remap = map.remap,
        silent = map.silent,
      }
      local mode = map.mode or "n"
      if map.ft then
        vim.api.nvim_create_autocmd("FileType", {
          pattern = map.ft,
          callback = function(ev)
            local local_opts = vim.deepcopy(opts)
            local_opts.buffer = ev.buf
            vim.keymap.set(mode, lhs, rhs, local_opts)
          end,
        })
      else
        vim.keymap.set(mode, lhs, rhs, opts)
      end
    end
  end
end

local function resolve_opts(specs)
  local opts = {}
  local has_opts = false
  for _, spec in ipairs(specs) do
    local value = spec.opts
    if type(value) == "function" then
      local base = has_opts and opts or {}
      local ok, ret = pcall(value, spec, base)
      if ok then
        opts = ret ~= nil and ret or base
        has_opts = true
      end
    elseif type(value) == "table" then
      opts = has_opts and deep_merge_lists(opts, value) or vim.deepcopy(value)
      has_opts = true
    end
  end
  return has_opts and opts or nil
end

function M.setup()
  local modules = list_plugin_modules()

  local groups = {}
  local ordered_names = {}

  local function add_spec(raw)
    raw = normalize_spec(raw)
    if type(raw) ~= "table" or not is_enabled(raw) then
      return
    end

    local deps = raw.dependencies
    if type(deps) == "table" then
      for _, dep in ipairs(deps) do
        add_spec(dep)
      end
    end

    local repo = raw[1] or raw.src
    if type(repo) ~= "string" or repo == "" then
      return
    end

    local name = plugin_name(raw)
    if not name then
      return
    end

    local group = groups[name]
    if not group then
      group = {
        name = name,
        pack_name = pack_name_for(name, raw.name),
        repo = repo,
        specs = {},
        optional_only = true,
      }
      groups[name] = group
      ordered_names[#ordered_names + 1] = name
    end

    group.specs[#group.specs + 1] = raw
    if raw.optional ~= true then
      group.optional_only = false
    end
  end

  for _, module_name in ipairs(modules) do
    local ok, specs = pcall(require, module_name)
    if ok then
      for _, spec in ipairs(normalize_top_level_specs(specs)) do
        add_spec(spec)
      end
    end
  end

  local active_groups = {}
  local pack_specs = {}
  for _, name in ipairs(ordered_names) do
    local group = groups[name]
    if group and not group.optional_only then
      active_groups[#active_groups + 1] = group
      pack_specs[#pack_specs + 1] = {
        src = resolve_source(group.repo),
        name = group.pack_name,
      }
    end
  end

  local pack_name_to_group = {}
  for _, group in ipairs(active_groups) do
    pack_name_to_group[group.pack_name] = group
  end

  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      if ev.data.kind ~= "install" and ev.data.kind ~= "update" then
        return
      end
      local group = pack_name_to_group[ev.data.spec.name]
      if not group then
        return
      end
      for _, spec in ipairs(group.specs) do
        call_build(spec)
      end
    end,
  })

  for _, group in ipairs(active_groups) do
    for _, spec in ipairs(group.specs) do
      if type(spec.init) == "function" then
        pcall(spec.init, spec)
      end
    end
  end

  vim.pack.add(pack_specs, { confirm = false, load = true })

  for _, group in ipairs(active_groups) do
    local opts = resolve_opts(group.specs)

    for _, spec in ipairs(group.specs) do
      apply_keys(spec.keys)
    end

    local has_config = false
    for _, spec in ipairs(group.specs) do
      if type(spec.config) == "function" then
        has_config = true
        pcall(spec.config, spec, opts)
      end
    end

    if group.name == "conform.nvim" and type(opts) == "table" and opts.format_on_save == nil then
      opts.format_on_save = {
        timeout_ms = 3000,
        lsp_format = "fallback",
      }
    end

    if not has_config and opts ~= nil then
      if group.name == "nvim-lspconfig" then
        apply_lsp(opts)
      else
        local setup_module = setup_modules[group.name]
        if setup_module then
          local ok, mod = pcall(require, setup_module)
          if ok and type(mod.setup) == "function" then
            local setup_ok, setup_err = pcall(mod.setup, opts)
            if not setup_ok then
              vim.notify(
                ("Failed to setup %s: %s"):format(group.name, tostring(setup_err)),
                vim.log.levels.ERROR,
                { title = "config.pack" }
              )
            end
          end
        end
      end
    end
  end
end

return M