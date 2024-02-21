local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Your config here
now(function() add({ source = 'neovim/nvim-lspconfig', depends = { 'williamboman/mason.nvim' } }) end)

later(...)

-- Return true to ignore base config
return false
