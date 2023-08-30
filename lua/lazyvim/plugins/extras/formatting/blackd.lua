return {
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			table.insert(opts.ensure_installed, "black")
			table.insert(opts.ensure_installed, "blackd-client")
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		opts = function(_, opts)
			local nls = require("null-ls")
			local helpers = require("null-ls.helpers")
			table.insert(opts.sources, {
				name = "blackd",
				method = nls.methods.FORMATTING,
				filetypes = { "python" },
				generator = helpers.formatter_factory({
					command = "blackd-client",
					to_stdin = true,
				}),
			})
		end,
	},
}
