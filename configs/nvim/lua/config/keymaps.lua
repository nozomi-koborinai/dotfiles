local map = vim.keymap.set

-- Snacks.bufdelete keeps the window layout intact, but on the last buffer that
-- would leave an empty window, so open the dashboard behind it first.
local function close_buffer(opts)
  local buf = vim.api.nvim_get_current_buf()
  if #vim.fn.getbufinfo({ buflisted = 1 }) <= 1 then
    Snacks.dashboard()
    vim.api.nvim_buf_delete(buf, opts)
  else
    Snacks.bufdelete(opts)
  end
end

-- Buffer navigation
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })

-- General
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>x", function()
  if vim.bo[vim.api.nvim_get_current_buf()].modified then
    vim.notify("Unsaved changes. Use <leader>wx to save & close, or <leader>X to discard.", vim.log.levels.WARN)
    return
  end
  close_buffer({})
end, { desc = "Close buffer" })
map("n", "<leader>X", function() close_buffer({ force = true }) end, { desc = "Close buffer (discard changes)" })
map("n", "<leader>wx", function()
  vim.cmd("w")
  close_buffer({})
end, { desc = "Save and close buffer" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
