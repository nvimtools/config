return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		{
			"Exafunction/codeium.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			cmd = "Codeium",
			build = ":Codeium Auth",
			opts = {},
		},
	},
	---@param opts cmp.ConfigSchema
	opts = function(_, opts)
		table.insert(opts.sources, 1, { name = "codeium", group_index = 2 })
		opts.sorting = opts.sorting or require("cmp.config.default")().sorting
	end,
}
