-- work/ 配下の新規 .md ファイルにテンプレートを自動挿入
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*/work/*.md",
  callback = function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    if #lines == 1 and lines[1] == "" then
      local date = os.date("%Y-%m-%d")
      local template = {
        "# " .. date,
        "",
        "## todo",
        "- [ ] ",
        "",
        "## memo",
        "",
      }
      vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
    end
  end,
})
