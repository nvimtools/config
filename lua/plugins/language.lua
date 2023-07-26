return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.highlight.disable = {
				"c",
			}
			vim.list_extend(opts.ensure_installed, {
				"jsonnet",
			})
			return opts
		end,
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
			{
				"lvimuser/lsp-inlayhints.nvim",
				event = "LspAttach",
			},
		},
		---@class PluginLspOpts
		opts = {
			capabilities = {
				textDocument = {
					foldingRange = {
						dynamicRegistration = false,
						lineFoldingOnly = true,
					},
				},
			},
			---@type lspconfig.options
			servers = {
				-- shell
				bashls = {},

				-- markdown
				marksman = {},

				-- misc
				yamlls = {
					---@param new_config lspconfig.options.yamlls
					on_new_config = function(new_config)
						new_config.settings.yaml.schemas = new_config.settings.yaml.schemas or {}
						vim.list_extend(new_config.settings.yaml.schemas, require("schemastore").yaml.schemas())
					end,
				},
				-- ltex = {},
				grammarly = {},
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
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = {
			"ThePrimeagen/refactoring.nvim",
		},
		opts = function(_, opts)
			local nls = require("null-ls")
			local helpers = require("null-ls.helpers")

			vim.list_extend(opts.sources, {
				-- python
				{
					name = "blackd",
					method = nls.methods.FORMATTING,
					filetypes = { "python" },
					generator = helpers.formatter_factory({
						command = "blackd-client",
						to_stdin = true,
					}),
				},
				nls.builtins.formatting.usort,

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
		{ import = "lazyvim.plugins.extras.lang.tailwind" },
		{ import = "lazyvim.plugins.extras.lang.go" },
		{ import = "lazyvim.plugins.extras.lang.rust" },
		{ import = "lazyvim.plugins.extras.lang.clangd" },
		{ import = "lazyvim.plugins.extras.lang.cmake" },
		{ import = "lazyvim.plugins.extras.lang.python" },
		{ import = "lazyvim.plugins.extras.lang.elixir" },
		{ import = "lazyvim.plugins.extras.lang.json" },
		{ import = "lazyvim.plugins.extras.linting.eslint" },
		{
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
		},
		{
			"eraserhd/parinfer-rust",
			build = "cargo build --release",
		},
		{
			"elkowar/yuck.vim",
			ft = { "yuck" },
		},
	},
	{ -- debug adapter
		{ import = "lazyvim.plugins.extras.dap.core" },
		{ import = "lazyvim.plugins.extras.dap.nlua" },
		{
			"jay-babu/mason-nvim-dap.nvim",
			opts = {
				ensure_installed = {
					-- python
					"python",

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
				-- python
				"black",
				"blackd-client",
				"usort",

				-- shell
				"shellcheck",

				-- haskell
				"haskell-debug-adapter",

				-- misc
				"editorconfig-checker",
				"jsonnet-language-server",
				-- "commitlint",
			})
			return opts
		end,
	},
}
