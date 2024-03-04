-- Do not wrap in a function if you'd like to override the supplied config
return function(...)
	local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

	-- Your config here
	now(function() add({ source = 'neovim/nvim-lspconfig', depends = { 'williamboman/mason.nvim' } }) end)

	later(...)
end
