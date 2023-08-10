return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-notify",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		"nvim-telescope/telescope-ghq.nvim",
		"nvim-telescope/telescope-github.nvim",
		-- "chip/telescope-software-licenses.nvim",
		"AckslD/nvim-neoclip.lua",
		"benfowler/telescope-luasnip.nvim",
		"jvgrootveld/telescope-zoxide",
		"tsakirist/telescope-lazy.nvim",
		"olacin/telescope-cc.nvim",
		"ThePrimeagen/refactoring.nvim",
	},
	config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)

		for _, extension in ipairs(opts.extensions) do
			telescope.load_extension(extension)
		end
	end,
	opts = {
		defaults = {
			prompt_prefix = " 󰍉 ",
			selection_caret = "󰅂 ",
		},
		extensions = {
			"fzf",
			"ghq",
			"gh",
			-- "software-licenses",
			"neoclip",
			"luasnip",
			"zoxide",
			"lazy",
			"conventional_commits",
			"refactoring",
		},
	},
	keys = {
		-- disable the keymap to grep files
		-- { "<leader>/", false },
		-- add a keymap to browse plugin files
		{
			"<leader>fp",
			function()
				require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
			end,
			desc = "Find Plugin File",
		},
	},
}
