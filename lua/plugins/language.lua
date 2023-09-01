return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			highlight = {
				disable = {
					"c",
				},
			},
		},
	},
	{ -- lsp
		"neovim/nvim-lspconfig",
		dependencies = {
			"b0o/SchemaStore.nvim",
			{
				"SmiteshP/nvim-navbuddy",
				dependencies = {
					"SmiteshP/nvim-navic",
					"MunifTanjim/nui.nvim",
				},
				opts = { lsp = { auto_attach = true } },
			},
		},
		---@class PluginLspOpts
		opts = {
			capabilities = {
				textDocument = {
					foldingRange = { -- for nvim-ufo
						dynamicRegistration = false,
						lineFoldingOnly = true,
					},
				},
			},
		},
		setup = {
			eslint = function()
				require("lazyvim.util").on_attach(function(client)
					if client.name == "eslint" then
						client.server_capabilities.documentFormattingProvider = true
					elseif client.name == "tsserver" then
						client.server_capabilities.documentFormattingProvider = false
					end
				end)
			end,
		},
	},
	{ -- null-ls
		"nvimtools/none-ls.nvim",
		dependencies = {
			"ThePrimeagen/refactoring.nvim",
		},
		opts = function(_, opts)
			local nls = require("null-ls")

			vim.list_extend(opts.sources, {
				-- git
				-- nls.builtins.diagnostics.commitlint,
				nls.builtins.code_actions.gitrebase,

				nls.builtins.diagnostics.actionlint.with({
					runtime_condition = function()
						local path = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
						return path:match("github/workflows/") ~= nil
					end,
				}),

				-- misc
				nls.builtins.diagnostics.rpmspec,

				nls.builtins.hover.dictionary,
				nls.builtins.diagnostics.editorconfig_checker,

				nls.builtins.code_actions.refactoring,
			})
			return opts
		end,
	},
	{ -- language specific settings
		{ import = "lazyvim.plugins.extras.lang.typescript" },
		{ import = "lazyvim.plugins.extras.linting.eslint" },
		{ import = "lazyvim.plugins.extras.lang.tailwind" },

		{ import = "lazyvim.plugins.extras.lang.go" },

		{ import = "lazyvim.plugins.extras.lang.rust" },

		{ import = "lazyvim.plugins.extras.lang.clangd" },
		{ import = "lazyvim.plugins.extras.lang.cmake" },

		{ import = "lazyvim.plugins.extras.lang.python" },
		{ import = "lazyvim.plugins.extras.formatting.blackd" },
		{ import = "lazyvim.plugins.extras.formatting.usort" },

		{ import = "lazyvim.plugins.extras.lang.elixir" },

		{ import = "lazyvim.plugins.extras.lang.json" },
		{ import = "lazyvim.plugins.extras.lang.jsonnet" },
		{ import = "lazyvim.plugins.extras.lang.yaml" },
		{ import = "lazyvim.plugins.extras.lang.dhall" },
		{ import = "lazyvim.plugins.extras.lang.docker" },
		{ import = "lazyvim.plugins.extras.lang.shell" },

		{ import = "lazyvim.plugins.extras.lang.haskell" },
		{ import = "lazyvim.plugins.extras.lang.yuck" },

		{ import = "lazyvim.plugins.extras.lang.markdown" },
	},
	{ -- debug adapter
		{ import = "lazyvim.plugins.extras.dap.core" },
		{ import = "lazyvim.plugins.extras.dap.nlua" },
		{
			"jay-babu/mason-nvim-dap.nvim",
			opts = {
				ensure_installed = {
					-- typescript
					"node2",
					"firefox",
					"chrome",
				},
			},
		},
	},
	{ -- tests
		{ import = "lazyvim.plugins.extras.test.core" },
	},

	{ -- dependencies
		"williamboman/mason.nvim",
		---@param opts MasonSettings | {ensure_installed: string[]}
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				-- misc
				"editorconfig-checker",
				"actionlint",
				-- "commitlint",
			})
			return opts
		end,
	},
}
