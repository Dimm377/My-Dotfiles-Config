local function get_caelestia_colors()
  local file = io.open(os.getenv("HOME") .. "/.local/state/caelestia/scheme.json", "r")
  if not file then return {} end
  
  local content = file:read("*a")
  file:close()
  
  local ok, parsed = pcall(vim.json.decode, content)
  if not ok or not parsed or not parsed.colours then return {} end
  
  local c = parsed.colours
  local overrides = {}
  
  for key, hex_code in pairs(c) do
    -- Only map valid hex strings (Catppuccin uses the same names internally)
    if type(hex_code) == "string" and #hex_code == 6 then
      overrides[key] = "#" .. hex_code
    end
  end
  
  return overrides
end

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      transparent_background = true,
      custom_highlights = function(colors)
        return {
          NormalFloat = { bg = "NONE" },
          FloatBorder = { bg = "NONE" },
          NeoTreeNormal = { bg = "NONE" },
          NeoTreeNormalNC = { bg = "NONE" },
          TelescopeNormal = { bg = "NONE" },
          TelescopeBorder = { bg = "NONE" },
          WhichKeyFloat = { bg = "NONE" },
        }
      end,
      color_overrides = {
        mocha = get_caelestia_colors(),
      },
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")

      -- Auto-reload theme LIVE when wallpaper changes!
      -- We must watch the directory because Caelestia atomic-replaces the file (inode changes)
      local dir = os.getenv("HOME") .. "/.local/state/caelestia"
      local w = (vim.uv or vim.loop).new_fs_event()
      w:start(dir, {}, vim.schedule_wrap(function(err, filename, events)
        if not err and filename == "scheme.json" then
          -- Wait 100ms to ensure Caelestia finished writing the file
          vim.defer_fn(function()
            local new_colors = get_caelestia_colors()
            if new_colors and new_colors.base then
              local new_opts = vim.deepcopy(opts)
              new_opts.color_overrides = { mocha = new_colors }
              require("catppuccin").setup(new_opts)
              vim.cmd.colorscheme("catppuccin")
            end
          end, 100)
        end
      end))
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
