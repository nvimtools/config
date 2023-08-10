return {
	{
		"akinsho/toggleterm.nvim",
		config = function(_, opts)
			require("toggleterm").setup(opts)
		end,
		---@type ToggleTermConfig
		opts = {
			open_mapping = "<c-`>",
			autochdir = true,
			-- direction = "float",
			-- winbar = {
			--   enabled = true,
			-- },
			shade_terminals = false,
		},
		cmd = "ToggleTerm",
		---@type LazyKeys{}
		keys = {
			"<c-`>",
		},
	},
}
