-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

vim.opt.relativenumber = false
vim.opt.listchars = {
  eol = "$",
  tab = "-»",
  trail = "~",
  extends = ">",
  precedes = "<",
}
vim.opt.list = false
vim.g.omni_sql_no_default_maps = 1
