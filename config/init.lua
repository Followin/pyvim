local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config")
require("lazy").setup("plugins")

vim.opt.shortmess = vim.opt.shortmess + { I = true }
vim.opt.listchars = {
  tab = ">·",
  trail = "·",
  extends = "»",
  precedes = "«",
  eol = "⏎",
}
vim.opt.list = true
vim.opt.relativenumber = true

vim.wo.number = true
vim.wo.signcolumn = 'yes'
vim.wo.wrap = false;

vim.o.mouse = 'a'
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.termguicolors = true
vim.o.completeopt = 'menuone'
vim.o.scrolloff = 5
vim.o.guifont = "JetBrainsMono Nerd Font:h8"

vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

vim.filetype.add({
  extension = {
    props = "xml",
    json = "jsonc",
    avsc = "jsonc",
  },
});

vim.o.clipboard = "unnamed"

vim.api.nvim_set_keymap("n", "j", "gj", { noremap = true })
vim.api.nvim_set_keymap("n", "k", "gk", { noremap = true })
