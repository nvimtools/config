return {
	{
		"gbprod/nord.nvim",
		opts = {
			transparent = false,
			borders = true,
			errors = { mode = "fg" },
			on_highlights = function(highlights, _)
				for group, highlight in pairs(highlights) do
					if vim.startswith(group, "CmpItemKind") then
						highlight["reverse"] = true
						highlight["blend"] = 0
					end
				end
				highlights["LspInlayHint"] = { fg = require("nord.colors").palette.polar_night.light }
			end,
		},
		lazy = true,
	},
}
