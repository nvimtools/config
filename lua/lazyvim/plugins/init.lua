require("lazyvim.config").init()

return {
  { "folke/lazy.nvim", version = "*" },
  { "daze", priority = 10000, lazy = false, config = true, cond = true },
}
