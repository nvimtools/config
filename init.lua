if vim.loader and vim.fn.has('nvim-0.9.1') == 1 then vim.loader.enable() end

local path_package = vim.fn.stdpath('data') .. '/site'

---@type table
local _deps

if not vim.loop.fs_stat(path_package .. '/pack/deps/start/mini.nvim') then
	_deps = require('_vendor.mini.deps')
	require('_vendor.mini.basics').setup()
else
	_deps = require('mini.deps')
end

local working, ret = pcall(function()
	_deps.setup({ path = { package = path_package } })

	local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

	add('echasnovski/mini.nvim')
	if
		vim.loop.fs_stat(path_package .. '/pack/deps/opt/mini.nvim')
		and not vim.loop.fs_stat(path_package .. '/pack/deps/start/mini.nvim')
	then
		vim.fn.mkdir(path_package .. '/pack/deps/start', 'p')
		vim.loop.fs_rename(path_package .. '/pack/deps/opt/mini.nvim', path_package .. '/pack/deps/start/mini.nvim')
	end

	---@type boolean, boolean
	local success, override = pcall(require, 'config')

	if (success and not override) or not success then
		now(function() require('mini.basics').setup() end)
		now(function()
			require('mini.notify').setup()
			vim.notify = require('mini.notify').make_notify()
		end)
		now(function() require('mini.statusline').setup() end)
		now(function() require('mini.starter').setup() end)

		-- load instantly to replace netrw
		now(function() require('mini.files').setup() end)

		later(function() require('mini.ai').setup() end)
		later(function() require('mini.comment').setup() end)
		later(function() require('mini.surround').setup() end)
		later(function() require('mini.pairs').setup() end)
		later(function() require('mini.completion').setup() end)
		later(function() require('mini.jump').setup() end)
		later(function() require('mini.pick').setup() end)
		later(
			function()
				require('mini.indentscope').setup({
					draw = { animation = require('mini.indentscope').gen_animation.none() },
				})
			end
		)
		later(function() require('mini.cursorword').setup() end)
		later(function() require('mini.bufremove').setup() end)
		later(function() require('mini.bracketed').setup() end)

		now(function()
			add({
				source = 'nvim-treesitter/nvim-treesitter',
				hooks = {
					post_checkout = function() vim.cmd('TSUpdate') end,
				},
			})
			require('nvim-treesitter.configs').setup({
				ensure_installed = { 'lua', 'vimdoc' },
				highlight = { enable = true },
			})
		end)
	end
end)

if not working then
	local failsafe_message = [[
(pure.nvim) launched in failsafe mode. Only basic editing features are available.

Possible reasons:
* Internet unreachable during bootstrap
* Broken `git` installation
* Wrong permissions on site path

Traceback:
]]
	vim.notify(failsafe_message .. ret, vim.log.levels.ERROR)

	require('_vendor.mini.ai').setup()
	require('_vendor.mini.comment').setup()
	require('_vendor.mini.surround').setup()
	require('_vendor.mini.pairs').setup()
	require('_vendor.mini.bufremove').setup()
	require('_vendor.mini.jump').setup()
end
