require("lazyvim.config").init()

return {
	{ "folke/lazy.nvim", version = "*" },
	{ "nvimtools/daze", priority = 10000, lazy = false, config = true, cond = true, version = "*" },
}
