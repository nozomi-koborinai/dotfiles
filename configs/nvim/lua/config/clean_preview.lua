local ok, err = xpcall(function()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then error("lazy.nvim is not installed") end
  vim.opt.rtp:prepend(lazypath)

  local Config = require("lazy.core.config")
  -- pkg.enabled stays false so Plugin.load does not call Pkg.update.
  Config.setup({
    spec = "plugins",
    install = { missing = false },
    checker = { enabled = false },
    change_detection = { enabled = false },
    rocks = { enabled = false },
    pkg = { enabled = false },
  })
  require("lazy.core.plugin").load()

  -- A broken spec is recorded, not raised, and would mark declared plugins for removal.
  for _, entry in ipairs(Config.spec.notifs) do
    if entry.level >= vim.log.levels.ERROR then error(entry.msg) end
  end

  for _, plugin in ipairs(Config.to_clean) do
    io.stdout:write("clean\t" .. plugin.name .. "\n")
  end
  io.stdout:write("ok\n")
  io.stdout:flush()
  vim.cmd("qa!")
end, debug.traceback)

if not ok then
  io.stderr:write(tostring(err) .. "\n")
  io.stderr:flush()
  vim.cmd("cquit")
end
