return {
	{
		"jhofscheier/ltex-utils.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-telescope/telescope.nvim",
		},
		opts = {},
		init = function()
			require("lazyvim.util").on_attach(function(client, bufnr)
				if client.name == "ltex" then
					require("ltex-utils").on_attach(bufnr)
				end
			end)
		end,
		event = "VeryLazy",
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				ltex = {
					settings = {
						ltex = {
							language = vim.env.LANGUAGETOOL_LANG or "en-US",
							additionalRules = {
								enablePickyRules = true,
								motherTongue = vim.env.LANGUAGETOOL_MOTHERTONGUE,
							},
							languageToolHttpServerUri = vim.env.LANGUAGETOOL_ENDPOINT,
							languageToolOrg = {
								username = vim.env.LANGUAGETOOL_USERNAME,
								apiKey = vim.env.LANGUAGETOOL_APIKEY,
							},
						},
					},
				},
			},
		},
	},
}
