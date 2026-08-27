vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("my.pack.build.blink", { clear = true }),
  callback = function(ev)
    if ev.data.spec.name ~= "blink.cmp" then
      return
    end
    if ev.data.kind ~= "install" and ev.data.kind ~= "update" then
      return
    end
    if vim.fn.executable("cargo") == 1 then
      pcall(function()
        require("blink.cmp").build({ force = true }):pwait()
      end)
    end
  end,
})

vim.pack.add({
  "https://github.com/saghen/blink.lib.git",
  "https://github.com/Kaiser-Yang/blink-cmp-git.git",
  "https://github.com/L3MON4D3/LuaSnip.git",
  "https://github.com/rafamadriz/friendly-snippets.git",
  "https://github.com/nvim-mini/mini.icons.git",
  "https://github.com/saghen/blink.cmp.git",
}, { confirm = false })

---@module 'blink.cmp'
---@type blink.cmp.Config
local opts = {
  keymap = {
    preset = "none",
    ["<CR>"] = { "accept", "fallback" },
    ["<C-y>"] = { "accept", "fallback" },

    ["<C-n>"] = { "select_next", "fallback" },
    ["<C-p>"] = { "select_prev", "fallback" },

    ["<C-e>"] = { "hide", "show", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
  },
  fuzzy = {
    implementation = vim.fn.executable("cargo") == 1 and "rust" or "lua",
    sorts = {
      'score',
      'sort_text',
      'label',
    }
  },
  cmdline = {
    enabled = true,
    completion = {
      ghost_text = { enabled = true },
    },
  },
  appearance = { use_nvim_cmp_as_default = true },
  completion = {
    ghost_text = {
      enabled = false,
    },
    menu = {
      border = "rounded",
      draw = {
        components = {
          kind_icon = {
            text = function(ctx)
              local ok, mini_icons = pcall(require, "mini.icons")
              if not ok then
                return ctx.kind_icon .. ctx.icon_gap
              end
              local icon = mini_icons.get("lsp", ctx.kind)
              return (icon or ctx.kind_icon) .. ctx.icon_gap
            end,
          },
        },
      },
    },
    documentation = {
      window = {
        border = "rounded",
      },
    },
  },
  snippets = {
    preset = "default",
  },
  sources = {
    default = { "git", "lsp", "path", "snippets", "buffer" },
    providers = {
      git = {
        module = "blink-cmp-git",
        name = "Git",
        enabled = function()
          return vim.tbl_contains({ "octo", "gitcommit", "markdown" }, vim.bo.filetype)
        end,
        --- @module 'blink-cmp-git'
        --- @type blink-cmp-git.Options
        opts = {
          commit = {
            triggers = { ";" },
          },
          git_centers = {
            github = {
              issue = {},
              pull_request = {},
              mention = {},
            },
          },
        },
      },
      -- emoji = {
      --   module = "blink-emoji",
      --   name = "Emoji",
      --   score_offset = 15,
      --   opts = {
      --     insert = true,
      --     ---@type string|table|fun():table
      --     trigger = function()
      --       return { ":" }
      --     end,
      --   },
      --   should_show_items = function()
      --     return vim.tbl_contains({ "gitcommit", "markdown" }, vim.o.filetype)
      --   end,
      -- },
    },
  },
}

local blink_initialized = false

local function setup_blink()
  if blink_initialized then
    return
  end
  blink_initialized = true

  local ok_luasnip, luasnip = pcall(require, "luasnip")
  if ok_luasnip then
    luasnip.config.setup({})
    pcall(function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end)
  end

  local ok_blink, blink = pcall(require, "blink.cmp")
  if not ok_blink then
    vim.notify("Failed to load blink.cmp", vim.log.levels.ERROR)
    return
  end
  blink.setup(opts)
end

vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  group = vim.api.nvim_create_augroup("my.lazy.blink", { clear = true }),
  once = true,
  callback = setup_blink,
})