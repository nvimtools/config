return {
	"hrsh7th/nvim-cmp",
	commit = "6c84bc75c64f778e9f1dcb798ed41c7fcb93b639", -- https://github.com/hrsh7th/nvim-cmp/pull/1691
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
