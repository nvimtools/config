-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.expandtab = false
opt.tabstop = 4
opt.shiftwidth = 0

-- opt.colorcolumn:append("80")
opt.colorcolumn:append("120")

opt.guifont = "monospace,emoji,Noto Sans Mono CJK TC,Noto Sans Mono CJK JP:h10"
vim.g.neovide_cursor_vfx_mode = "pixiedust"

vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0
