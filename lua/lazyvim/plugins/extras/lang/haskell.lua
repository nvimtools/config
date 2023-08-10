return {
	"mrcjkb/haskell-tools.nvim",
	ft = { "haskell" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		local ht = require("haskell-tools")
		ht.start_or_attach()
	end,
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
}
