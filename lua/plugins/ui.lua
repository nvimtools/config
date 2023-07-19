return {

	{ -- colorscheme
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
				end,
			},
			module = true,
			lazy = true,
			-- priority = 1000,
		},
		{
			"LazyVim/LazyVim",
			opts = {
				colorscheme = "nord",
			},
		},

		{ -- disable builtin ones
			{
				"folke/tokyonight.nvim",
				enabled = false,
			},
			{
				"catppuccin",
				enabled = false,
			},
		},
	},

	{ -- sidepanels
		{
			"akinsho/bufferline.nvim",
			dependencies = {
				"gbprod/nord.nvim",
			},
			---@param opts bufferline.UserConfig
			opts = function(_, opts)
				local options = opts.options
				options.always_show_bufferline = true
				options.offsets = {
					{
						filetype = "neo-tree",
						text = "File Explorer",
						highlight = "Directory",
						text_align = "left",
					},
				}
				if vim.opt.mousemoveevent then
					options.hover = {
						enabled = true,
						delay = 100,
						reveal = { "close" },
					}
				end
				options.separator_style = "thin"
				options.highlights = require("nord.plugins.bufferline").akinsho()
				options.buffer_close_icon = "󰖭"
				options.close_icon = "󰅙 "
				options.modified_icon = "󰛿"
				options.left_trunc_marker = "󰄽"
				options.right_trunc_marker = "󰄾"
			end,
		},

		{
			{ import = "lazyvim.plugins.extras.ui.edgy" },
			{
				"nvim-neo-tree/neo-tree.nvim",
				opts = {
					window = {
						position = "left",
					},
					default_component_configs = {
						icon = {
							folder_closed = "󰉋",
							folder_open = "󰉖",
							folder_empty = "󱞞",
						},
						modified = {
							symbol = "󰏫",
							highlight = "NeoTreeModified",
						},
						git_status = {
							symbols = {
								untracked = "󰋗",
								ignored = "󰘓",
								unstaged = "󰏫",
								staged = "󰠘",
								conflict = "󰓧",
							},
						},
					},
					filesystem = {
						follow_current_file = {
							enabled = true,
						},
						use_libuv_file_watcher = true,
					},
				},
			},
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
					dashboard.button("f", "󰱼 " .. " Find file", ":Telescope find_files <CR>"),
					dashboard.button("n", "󱪝 " .. " New file", ":ene <BAR> startinsert <CR>"),
					dashboard.button("r", "󰋚 " .. " Recent files", ":Telescope oldfiles <CR>"),
					dashboard.button("g", "󰈞 " .. " Find text", ":Telescope live_grep <CR>"),
					dashboard.button("c", "󱁻 " .. " Config", ":e $MYVIMRC <CR>"),
					dashboard.button("q", "󰈆 " .. " Quit", ":qa<CR>"),
				}
				dashboard.section.footer.val = ""

				dashboard.opts.layout[1].val = 8
				return dashboard
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
			"rcarriga/nvim-notify",
			opts = {
				-- background_colour = "NormalFloat",
				-- fps = 15,
				icons = {
					DEBUG = "󰃤",
					ERROR = "󰅙",
					INFO = "󰋼",
					TRACE = "󰤀",
					WARN = "󰀦",
				},
			},
		},
		{
			"folke/zen-mode.nvim",
			cmd = "ZenMode",
			---@type ZenOptions
			opts = {
				-- on_open = function(win)
				--   vim.api.nvim_win_set_option(require("zen-mode.view").bg_win, "winhighlight", "NormalFloat:Normal")
				--   vim.api.nvim_win_set_option(win, "winhighlight", "Normal:ZenBg")
				-- end,
			},
		},
		{
			"folke/twilight.nvim",
			cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
		},
		{
			"m4xshen/hardtime.nvim",
			event = "VeryLazy",
			opts = {
				disable_mouse = false,
			},
		},
	},
}