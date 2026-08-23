local map = vim.keymap.set

-- Buffer navigation
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })

-- General
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>x", function()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].modified then
    vim.notify("Unsaved changes. Use <leader>wx to save & close, or <leader>X to discard.", vim.log.levels.WARN)
    return
  end
  local listed = vim.fn.getbufinfo({ buflisted = 1 })
  if #listed <= 1 then
    Snacks.dashboard()
    vim.api.nvim_buf_delete(buf, {})
  else
    Snacks.bufdelete()
  end
end, { desc = "Close buffer" })
map("n", "<leader>X", function()
  local buf = vim.api.nvim_get_current_buf()
  local listed = vim.fn.getbufinfo({ buflisted = 1 })
  if #listed <= 1 then
    Snacks.dashboard()
    vim.api.nvim_buf_delete(buf, { force = true })
  else
    Snacks.bufdelete({ force = true })
  end
end, { desc = "Close buffer (discard changes)" })
map("n", "<leader>wx", function()
  vim.cmd("w")
  local buf = vim.api.nvim_get_current_buf()
  local listed = vim.fn.getbufinfo({ buflisted = 1 })
  if #listed <= 1 then
    Snacks.dashboard()
    vim.api.nvim_buf_delete(buf, {})
  else
    Snacks.bufdelete()
  end
end, { desc = "Save and close buffer" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
