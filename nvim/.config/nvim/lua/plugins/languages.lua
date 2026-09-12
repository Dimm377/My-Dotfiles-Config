return {
  -- Ensure treesitter parsers are installed
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "bash",
          "c",
          "cpp",
          "css",
          "go",
          "html",
          "javascript",
          "json",
          "lua",
          "python",
          "rust",
          "typescript",
          "tsx",
        })
      end
    end,
  },

  -- Ensure mason tools (LSPs, Formatters, Linters) are installed
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "bash-language-server",
          "shfmt",
          "shellcheck",
          "stylua",
        })
      end
    end,
  },
}
