-- Hammerspoon: window management behind a leader key
-- Leader: Ctrl+A → {action key}

local leader = hs.hotkey.modal.new()
local timeout = hs.timer.delayed.new(1.5, function() leader:exit() end)

hs.hotkey.bind("ctrl", "a", function() leader:enter() end)

leader:entered(function()
  hs.alert.show("Leader", 0.5)
  timeout:start()
end)

leader:exited(function() timeout:stop() end)

-- Move the mouse to the centre of the window
local function centerMouse(win)
  if not win then return end
  local f = win:frame()
  hs.mouse.setAbsolutePosition({ x = f.x + f.w / 2, y = f.y + f.h / 2 })
end

-- Hide the app when it already has focus, otherwise bring it up. Apps whose
-- bundle name differs from their process name (Ableton, for one) are launched
-- and matched by bundle ID instead.
local function toggleApp(appName, bundleID)
  local app = hs.application.frontmostApplication()
  local focused = app and ((bundleID and app:bundleID() == bundleID) or (not bundleID and app:name() == appName))
  if focused then
    app:hide()
  else
    if bundleID then
      hs.application.launchOrFocusByBundleID(bundleID)
    else
      hs.application.launchOrFocus(appName)
    end
    hs.timer.doAfter(0.2, function() centerMouse(hs.window.focusedWindow()) end)
  end
  leader:exit()
end

----------------------------------------------------
-- Window
----------------------------------------------------

-- z: maximize, matching WezTerm's Leader+z
leader:bind("", "z", function()
  local win = hs.window.focusedWindow()
  if win then win:maximize() end
  leader:exit()
end)

-- hjkl: move focus to the window in that direction
local directions = {
  h = "West",
  j = "South",
  k = "North",
  l = "East",
}

for key, dir in pairs(directions) do
  leader:bind("", key, function()
    local win = hs.window.focusedWindow()
    if win then win["focusWindow" .. dir](win) end
    centerMouse(hs.window.focusedWindow())
    leader:exit()
  end)
end

-- Shift + HJKL: move the active window to the display in that direction
for key, dir in pairs(directions) do
  leader:bind("shift", key, function()
    local win = hs.window.focusedWindow()
    if win then
      local target = win:screen()["to" .. dir](win:screen())
      if target then win:moveToScreen(target) end
      centerMouse(win)
    end
    leader:exit()
  end)
end

----------------------------------------------------
-- App focus / toggle
----------------------------------------------------

-- b: Browser (Chrome)
leader:bind("", "b", function() toggleApp("Google Chrome") end)

-- q: Terminal (WezTerm)
leader:bind("", "q", function() toggleApp("WezTerm") end)

-- s: Cursor
leader:bind("", "s", function() toggleApp("Cursor") end)

-- e: Ableton Live
leader:bind("", "e", function() toggleApp("Live", "com.ableton.live") end)

-- g: Grok Bot
leader:bind("", "g", function() toggleApp("Grok Bot") end)

----------------------------------------------------
-- Split: two windows side by side at a given ratio.
-- The focused window takes the left, the one behind it the right.
----------------------------------------------------

local function splitWindows(leftRatio)
  local wins = hs.window.orderedWindows()
  local focused = wins[1]
  if not focused then return end

  local screen = focused:screen()
  local f = screen:frame()

  focused:setFrame({
    x = f.x,
    y = f.y,
    w = f.w * leftRatio,
    h = f.h,
  })

  for i = 2, #wins do
    if wins[i]:screen() == screen then
      wins[i]:setFrame({
        x = f.x + f.w * leftRatio,
        y = f.y,
        w = f.w * (1 - leftRatio),
        h = f.h,
      })
      break
    end
  end

  centerMouse(focused)
  leader:exit()
end

-- The digit picks the left window's share: 1:1, 2:1, 3:1
leader:bind("", "1", function() splitWindows(1 / 2) end)
leader:bind("", "2", function() splitWindows(2 / 3) end)
leader:bind("", "3", function() splitWindows(3 / 4) end)

-- Esc: cancel
leader:bind("", "escape", function() leader:exit() end)

----------------------------------------------------
-- Cursor split: Cursor.app on the left 65%, WezTerm on the right 35%.
-- bin/nzm-cursor-split reaches this through hammerspoon://cursor-split-start
----------------------------------------------------

local function cursorSplitFrames(screen)
  local f = screen:frame()
  local leftWidth = f.w * 0.65
  return { x = f.x, y = f.y, w = leftWidth, h = f.h }, { x = f.x + leftWidth, y = f.y, w = f.w - leftWidth, h = f.h }
end

local function getCursorWindowIds()
  local ids = {}
  local app = hs.application.get("Cursor")
  if app then
    for _, win in ipairs(app:allWindows()) do
      ids[win:id()] = true
    end
  end
  return ids
end

local function findNewCursorWindow(existingIds)
  local app = hs.application.get("Cursor")
  if not app then return nil end
  for _, win in ipairs(app:allWindows()) do
    if not existingIds[win:id()] then return win end
  end
  return nil
end

local function getWezTermWindow()
  local app = hs.application.get("WezTerm")
  if not app then return nil end
  return app:mainWindow()
end

hs.urlevent.bind("cursor-split-start", function()
  local wt = getWezTermWindow()
  if not wt then
    hs.alert.show("cursor-split: WezTerm not running")
    return
  end

  local leftFrame, rightFrame = cursorSplitFrames(wt:screen())
  wt:setFrame(rightFrame)

  -- Note which windows Cursor already has, so the one it opens next stands out
  local existingIds = getCursorWindowIds()

  local newWin = findNewCursorWindow(existingIds)
  if newWin then
    newWin:setFrame(leftFrame)
    wt:focus()
    return
  end

  local attempts = 0
  local poller
  poller = hs.timer.doEvery(0.2, function()
    attempts = attempts + 1
    local win = findNewCursorWindow(existingIds)
    if win then
      win:setFrame(leftFrame)
      poller:stop()
      wt:focus()
    elseif attempts >= 25 then
      poller:stop()
      -- Fall back to whatever main window Cursor already had
      local app = hs.application.get("Cursor")
      if app and app:mainWindow() then
        app:mainWindow():setFrame(leftFrame)
        wt:focus()
      else
        hs.alert.show("cursor-split: cursor window not found")
      end
    end
  end)
end)
