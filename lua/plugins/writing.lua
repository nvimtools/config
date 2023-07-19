return {
	{ -- FIXME: broken for now, see https://sr.ht/~self/nvp and https://github.com/nvimtools for a fork
		"toppair/peek.nvim",
		enabled = false,
		setup = function(_, opts)
			require("peek").setup(opts)

			vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
			vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
		end,
		build = "deno task --quiet build:fast",
		ft = { "markdown" },
		cmd = { "PeekOpen", "PeekClose" },
	},
	{
		"iamcco/markdown-preview.nvim",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		setup = function()
			vim.g.mkdp_page_title = "${name}"
		end,
		ft = { "markdown" },
	},
}
