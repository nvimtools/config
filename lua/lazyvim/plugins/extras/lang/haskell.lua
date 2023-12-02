return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "haskell" })
      end
    end,
  },
  {
    "mrcjkb/haskell-tools.nvim",
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope.nvim",
        optional = true,
      },
      {
        "nvim-lspconfig",
        optional = true,
        opts = {
          setup = {
            hls = function()
              return true -- avoid duplicate hls
            end,
          },
        },
      },
      {
        "mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "haskell-language-server", "ormolu" })
        end,
      },
    },
    version = "^3",
    keys = {
      {
        "<space>ch",
        function()
          require("haskell-tools").hoogle.hoogle_signature()
        end,
        mode = "n",
        desc = "Hoogle Signature",
      },
      {
        "<space>ce",
        function()
          require("haskell-tools").lsp.buf_eval_all()
        end,
        mode = "n",
        desc = "Eval All",
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "haskell-debug-adapter" })
        end,
      },
    },
  },
}
