return {
	{ "wakatime/vim-wakatime" },
	-- diff
	{
		{
			"sindrets/diffview.nvim",
			event = "VeryLazy",
		},
		{
			"akinsho/git-conflict.nvim",
			opts = {
				disable_diagnostics = true,
				default_mappings = {
					prev = "[x",
					next = "]x",
				},
			},
		},
	},

	-- folding support
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
			{
				"luukvbaal/statuscol.nvim",
				config = function()
					local builtin = require("statuscol.builtin")
					require("statuscol").setup({
						-- foldfunc = "builtin",
						-- setopt = true,
						relculright = true,
						segments = {
							{ text = { builtin.foldfunc }, click = "v:lua.ScFa" },
							{ text = { "%s" }, click = "v:lua.ScSa" },
							{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
						},
					})
				end,
			},
			"nvim-treesitter/nvim-treesitter",
		},
		event = "BufReadPost",
		opts = {
			provider_selector = function(bufnr, filetype, buftype)
				local ft_map = {
					yuck = "treesitter",
				}
				local ft_ignore = { "neo-tree", "git", "alpha" }

				for _, ft in ipairs(ft_ignore) do
					ft_map[ft] = ""
				end

				local function fallback(err, provider)
					if type(err) == "string" and err:match("UfoFallbackException") then
						return require("ufo").getFolds(bufnr, provider)
					else
						return require("promise").reject(err)
					end
				end

				return ft_map[filetype]
					or function()
						return require("ufo")
							.getFolds(bufnr, "lsp")
							:catch(function(err)
								return fallback(err, "treesitter")
							end)
							:catch(function(err)
								if buftype == "nofile" then
									return ""
								end
								return fallback(err, "indent")
							end)
					end
			end,
			open_fold_hl_timeout = 400,
			close_fold_kinds = { "imports", "comment" },
			preview = {
				win_config = {
					border = { "", "─", "", "", "", "─", "", "" },
					-- winhighlight = "Normal:Folded",
					winblend = 0,
				},
				mappings = {
					scrollU = "<C-u>",
					scrollD = "<C-d>",
					jumpTop = "[",
					jumpBot = "]",
				},
			},

			fold_virt_text_handler = function(virtual_text, foldstart, foldend, width, truncate)
				local max_width = 120 -- FIXME: hardcode this for now
				local result = {}

				local total_lines = vim.api.nvim_buf_line_count(0)
				local folded_lines = foldend - foldstart

				local fold_hint = ("  %d %d%%"):format(folded_lines, folded_lines / total_lines * 100)
				local hint_width = vim.fn.strdisplaywidth(fold_hint)
				local target_width = width - hint_width
				local cur_width = 0

				for _, chunk in ipairs(virtual_text) do
					local chunk_text = chunk[1]
					local chunk_width = vim.fn.strdisplaywidth(chunk_text)

					if target_width > cur_width + chunk_width then
						table.insert(result, chunk)
					else
						chunk_text = truncate(chunk_text, target_width - cur_width)

						local hl = chunk[2]
						table.insert(result, { chunk_text, hl })

						chunk_width = vim.fn.strdisplaywidth(chunk_text)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if cur_width + chunk_width < target_width then
							fold_hint = fold_hint .. (" "):rep(target_width - cur_width - chunk_width)
						end
						break
					end
					cur_width = cur_width + chunk_width
				end

				local padding = math.max(math.min(max_width, width - 1) - cur_width - hint_width, 0)
				fold_hint = (" "):rep(padding) .. fold_hint
				table.insert(result, { fold_hint, "MoreMsg" })
				return result
			end,
		},
		init = function()
			local opt = vim.opt
			opt.fillchars = {
				eob = " ",
				fold = " ",
				foldopen = "",
				foldsep = " ",
				foldclose = "",
			}
			opt.foldcolumn = "1"
			opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			opt.foldlevelstart = 99 -- do not autofold
			opt.foldenable = true
		end,
		keys = {
			{
				"Z",
				function()
					require("ufo").peekFoldedLinesUnderCursor()
				end,
				mode = "n",
				desc = "Hover",
			},
			{
				"zR",
				function()
					require("ufo").openAllFolds()
				end,
				mode = "n",
				desc = "Open all folds",
			},
			{
				"zM",
				function()
					require("ufo").closeAllFolds()
				end,
				mode = "n",
				desc = "Close all folds",
			},
			{
				"zr",
				function()
					require("ufo").openFoldsExceptKinds()
				end,
				mode = "n",
				desc = "Fold less",
			},
			{
				"zm",
				function(level)
					require("ufo").closeFoldsWith(level)
				end,
				mode = "n",
				desc = "Fold more",
			},
		},
	},

	-- autocomplete
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-emoji",
			{ -- AI code completions
				{ import = "lazyvim.plugins.extras.coding.codeium" },
			},
		},
		---@param opts cmp.ConfigSchema
		opts = function(_, opts)
			if false then
				local has_words_before = function()
					unpack = unpack or table.unpack
					local line, col = unpack(vim.api.nvim_win_get_cursor(0))
					return col ~= 0
						and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
				end

				local luasnip = require("luasnip")
				local cmp = require("cmp")

				opts.mapping = vim.tbl_extend("force", opts.mapping, {
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
						-- this way you will only jump inside the snippet region
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				})
			end

			-- table.insert(opts.sources, 1, { name = "cmp_tabnine", group_index = 2 })
			-- table.insert(opts.sources, 1, { name = "codeium", group_index = 2 })
			table.insert(opts.sources, { name = "emoji" })

			opts.window = vim.tbl_deep_extend("force", opts.window or {}, {
				completion = {
					col_offset = -3,
					side_padding = 0,
				},
			})
			opts.formatting = vim.tbl_deep_extend("force", opts.formatting or {}, {
				fields = { "kind", "abbr", "menu" },
				format = function(_, item)
					local icons = require("lazyvim.config").icons.kinds
					item.menu = "    ▏" .. item.kind
					item.kind = " " .. (icons[item.kind] or "  ")
					return item
				end,
			})

			return opts
		end,
	},
}
