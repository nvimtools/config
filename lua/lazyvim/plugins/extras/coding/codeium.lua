return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		{
			"Exafunction/codeium.nvim",
			event = "VeryLazy",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			config = function()
				require("codeium").setup({})
			end,
		},
	},
	---@param opts cmp.ConfigSchema
	opts = function(_, opts)
		table.insert(opts.sources, 1, { name = "codeium", group_index = 2 })
		opts.sorting = opts.sorting or require("cmp.config.default")().sorting
	end,
}
