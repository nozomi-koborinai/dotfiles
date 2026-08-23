vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.spell = false
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.scrolloff = 8
vim.opt.wrap = false
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.swapfile = false

-- 背景透過（WezTerm の透過と合わせる）
local function set_transparent_bg()
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NeoTreeStatusLine", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NeoTreeStatusLineNC", { bg = "NONE" })
end

vim.api.nvim_create_autocmd("ColorScheme", { callback = set_transparent_bg })

-- Dashboard の色を青に統一
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dashboard",
  callback = function()
    vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#589df6" })
    vim.api.nvim_set_hl(0, "DashboardIcon", { fg = "#589df6" })
    vim.api.nvim_set_hl(0, "DashboardKey", { fg = "#7ab8ff" })
    vim.api.nvim_set_hl(0, "DashboardDesc", { fg = "#aaccff" })
  end,
})
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.defer_fn(set_transparent_bg, 10)
  end,
})
