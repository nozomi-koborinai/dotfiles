-- Leader key, set before lazy.nvim loads
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if vim.env.DOTFILES_NVIM_CLEAN_PREVIEW == "1" then
  require("config.clean_preview")
  return
end

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Config
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Plugins
require("lazy").setup("plugins", {
  install = { colorscheme = { "gruvbox-material" } },
  checker = { enabled = false },
  change_detection = { notify = false },
})
