return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		{
			"jcdickinson/codeium.nvim",
			event = "VeryLazy",
			dependencies = {
				{
					"jcdickinson/http.nvim",
					build = "cargo build --workspace --release",
				},
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
