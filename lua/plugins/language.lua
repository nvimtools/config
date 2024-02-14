return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			indent = {
				enable = false,
			},
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
			servers = {
				pyright = {
					mason = false,
					cmd = { "delance-langserver", "--stdio" },
				},
			},
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
					elseif client.name == "typescript-tools" or client.name == "biome" then
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.documentRangeFormattingProvider = false
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

				nls.builtins.code_actions.refactoring,
			})
			return opts
		end,
	},
	{ -- language specific settings
		{ import = "lazyvim.plugins.extras.lang.typescript" },
		{ import = "lazyvim.plugins.extras.linting.eslint" },
		{ import = "lazyvim.plugins.extras.formatting.biome" },

		{ import = "lazyvim.plugins.extras.lang.tailwind" },

		{ import = "lazyvim.plugins.extras.lang.go" },

		{ import = "lazyvim.plugins.extras.lang.rust" },

		{ import = "lazyvim.plugins.extras.lang.clangd" },
		{ import = "lazyvim.plugins.extras.lang.cmake" },
		{ import = "lazyvim.plugins.extras.lang.meson" },

		{ import = "lazyvim.plugins.extras.lang.python" },
		{ import = "lazyvim.plugins.extras.formatting.black" },

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
		{ import = "lazyvim.plugins.extras.linting.ltex" },
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
				"actionlint",
				-- "commitlint",
			})
			return opts
		end,
	},
}
