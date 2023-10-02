return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"elixir",
				"heex",
				"eex",
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		opts = function(_, opts)
			local nls = require("null-ls")
			opts.sources = opts.sources or {}
			vim.list_extend(opts.sources, {
				nls.builtins.diagnostics.credo,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				elixirls = {},
			},
		},
	},
	{
		"nvim-neotest/neotest",
		optional = true,
		dependencies = {
			"jfpedroza/neotest-elixir",
		},
		opts = {
			adapters = {
				["neotest-elixir"] = {},
			},
		},
	},
}
