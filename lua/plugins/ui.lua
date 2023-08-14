return {
	{ -- sidepanels
		-- { import = "lazyvim.plugins.extras.ui.edgy" },
		{
			"akinsho/bufferline.nvim",
			dependencies = {
				"gbprod/nord.nvim",
			},
			---@param opts bufferline.UserConfig
			opts = function(_, opts)
				local options = opts.options
				if vim.opt.mousemoveevent then
					options.hover = {
						enabled = true,
						delay = 100,
						reveal = { "close" },
					}
				end
				options.highlights = require("nord.plugins.bufferline").akinsho()
			end,
		},
	},

	{ -- dashboard
		{
			"goolord/alpha-nvim",
			opts = function()
				local dashboard = require("alpha.themes.dashboard")
				local blackheart = {
					[[                                                        ]],
					[[  |_  |  _.  _ | , |_   _,  _. ,_ _|_   ,_     . ,_ _   ]],
					[[  |_) | (_| (_ |(_ | | (-` (_| |   |  o | | \/ | | | |  ]],
					[[                                                        ]],
					[[       不 能 讓 玩 家 再 為 魔 改 多 出 一 分 錢        ]],
					[[                                                        ]],
				}

				dashboard.section.header.val = blackheart
				dashboard.section.buttons.val = {
					dashboard.button(" f ", "󰱼 " .. " Find file", ":Telescope find_files <CR>"),
					dashboard.button(" n ", "󱪝 " .. " New file", ":ene <BAR> startinsert <CR>"),
					dashboard.button(" r ", "󰋚 " .. " Recent files", ":Telescope oldfiles <CR>"),
					dashboard.button(" g ", "󰈞 " .. " Find text", ":Telescope live_grep <CR>"),
					dashboard.button(" c ", "󱁻 " .. " Config", ":e $MYVIMRC <CR>"),
					dashboard.button(" q ", "󰈆 " .. " Quit", ":qa<CR>"),
				}
				local c = require("nord.colors")
				vim.api.nvim_set_hl(0, "AlphaHeader", { fg = c.palette.snow_storm.brightest, bold = true })
				vim.api.nvim_set_hl(0, "AlphaButtons", { link = "Normal" })
				vim.api.nvim_set_hl(
					0,
					"AlphaShortcut",
					{ bg = c.palette.frost.artic_ocean, fg = c.palette.origin, bold = true }
				)
				vim.api.nvim_set_hl(0, "AlphaFooter", { link = "Comment" })
				for _, button in ipairs(dashboard.section.buttons.val) do
					button.opts.hl = "AlphaButtons"
					button.opts.hl_shortcut = "AlphaShortcut"
				end
				dashboard.section.header.opts.hl = "AlphaHeader"
				dashboard.section.buttons.opts.hl = "AlphaButtons"
				dashboard.section.footer.opts.hl = "AlphaFooter"
				dashboard.section.footer.val = ""

				dashboard.opts.layout[1].val = 8
				return dashboard
			end,
			config = function(_, dashboard)
				-- close Lazy and re-open when the dashboard is ready
				if vim.o.filetype == "lazy" then
					vim.cmd.close()
					vim.api.nvim_create_autocmd("User", {
						pattern = "AlphaReady",
						callback = function()
							require("lazy").show()
						end,
					})
				end

				require("alpha").setup(dashboard.opts)

				vim.api.nvim_create_autocmd("User", {
					pattern = "LazyVimStarted",
					callback = function()
						local stats = require("lazy").stats()
						local v = vim.version()
						local version = string.format(
							"%d.%d" .. (v.prerelease and " (Nightly)" or ".%d"),
							v.major,
							v.minor,
							v.patch
						)
						local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
						dashboard.section.footer.val = {
							"Neovim " .. version,
							"lazy.nvim " .. require("lazy.core.config").version,
							string.format("%d mods loaded, %d mods active (%.2fms)", stats.loaded, stats.count, ms)
								.. string.rep(" ", 10),
						}

						pcall(vim.cmd.AlphaRedraw)
					end,
				})
			end,
		},
	},

	{ -- buffer enhancements
		{ import = "lazyvim.plugins.extras.util.mini-hipatterns" },
		{
			"lewis6991/satellite.nvim",
			dependencies = {
				"lewis6991/gitsigns.nvim",
			},
			event = "VeryLazy",
			opts = {
				excluded_filetypes = { "alpha", "dashboard", "neo-tree", "noice", "prompt", "TelescopePrompt" },
			},
		},
	},

	{ -- aesthetics
		{
			"m4xshen/hardtime.nvim",
			event = "VeryLazy",
			opts = {
				disable_mouse = false,
			},
		},
	},
}
