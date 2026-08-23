local wezterm = require("wezterm")
local act = wezterm.action

-- Show leader / key table status in the right status area
wezterm.on("update-right-status", function(window, pane)
  local status = ""
  if window:leader_is_active() then
    status = "LEADER"
  else
    local name = window:active_key_table()
    if name then status = "TABLE: " .. name end
  end
  window:set_right_status(status)
end)

return {
  keys = {
    -- Switch workspace
    {
      key = "w",
      mods = "LEADER",
      action = act.ShowLauncherArgs({ flags = "WORKSPACES", title = "Select workspace" }),
    },
    -- Rename the current workspace
    {
      key = "$",
      mods = "LEADER",
      action = act.PromptInputLine({
        description = "(wezterm) Set workspace title:",
        action = wezterm.action_callback(function(win, pane, line)
          if line then wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line) end
        end),
      }),
    },
    -- Create a workspace
    {
      key = "W",
      mods = "LEADER|SHIFT",
      action = act.PromptInputLine({
        description = "(wezterm) Create new workspace:",
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:perform_action(
              act.SwitchToWorkspace({
                name = line,
              }),
              pane
            )
          end
        end),
      }),
    },
    { key = "p", mods = "SUPER", action = act.ActivateCommandPalette },

    -- Tabs
    { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
    { key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
    { key = "{", mods = "LEADER", action = act({ MoveTabRelative = -1 }) },
    { key = "}", mods = "LEADER", action = act({ MoveTabRelative = 1 }) },
    { key = "t", mods = "SUPER", action = act({ SpawnTab = "CurrentPaneDomain" }) },
    { key = "w", mods = "SUPER", action = act({ CloseCurrentTab = { confirm = true } }) },

    { key = "Enter", mods = "ALT", action = act.ToggleFullScreen },

    -- Jump between prompts, skipping over long output
    { key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
    { key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },

    -- QuickSelect: label what is on screen, then copy it with a single key
    { key = "Space", mods = "LEADER", action = act.QuickSelect },
    -- QuickSelect, narrowed to URLs, opening the match in a browser
    {
      key = "u",
      mods = "LEADER",
      action = act.QuickSelectArgs({
        label = "open url",
        patterns = { "https?://\\S+" },
        action = wezterm.action_callback(function(window, pane)
          local url = window:get_selection_text_for_pane(pane)
          wezterm.open_with(url)
        end),
      }),
    },

    -- Emoji / Nerd Font picker
    { key = "e", mods = "LEADER", action = act.CharSelect({ copy_on_select = true }) },

    { key = "[", mods = "LEADER", action = act.ActivateCopyMode },

    -- Clipboard
    { key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
    { key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },

    -- Panes: split, close, rearrange
    { key = "d", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "r", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "x", mods = "LEADER", action = act({ CloseCurrentPane = { confirm = true } }) },
    { key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },
    { key = "S", mods = "LEADER|SHIFT", action = act.PaneSelect({ mode = "SwapWithActive" }) },
    -- Panes: move focus
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
    { key = "[", mods = "CTRL|SHIFT", action = act.PaneSelect },
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
    -- Panes: jump straight to one by number
    { key = "1", mods = "LEADER", action = act.ActivatePaneByIndex(0) },
    { key = "2", mods = "LEADER", action = act.ActivatePaneByIndex(1) },
    { key = "3", mods = "LEADER", action = act.ActivatePaneByIndex(2) },
    { key = "4", mods = "LEADER", action = act.ActivatePaneByIndex(3) },

    -- Font size
    { key = "+", mods = "CTRL", action = act.IncreaseFontSize },
    { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
    { key = "0", mods = "CTRL", action = act.ResetFontSize },

    -- Switch tab by number
    { key = "1", mods = "SUPER", action = act.ActivateTab(0) },
    { key = "2", mods = "SUPER", action = act.ActivateTab(1) },
    { key = "3", mods = "SUPER", action = act.ActivateTab(2) },
    { key = "4", mods = "SUPER", action = act.ActivateTab(3) },
    { key = "5", mods = "SUPER", action = act.ActivateTab(4) },
    { key = "6", mods = "SUPER", action = act.ActivateTab(5) },
    { key = "7", mods = "SUPER", action = act.ActivateTab(6) },
    { key = "8", mods = "SUPER", action = act.ActivateTab(7) },
    { key = "9", mods = "SUPER", action = act.ActivateTab(-1) },

    { key = "p", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
    { key = "r", mods = "SHIFT|CTRL", action = act.ReloadConfiguration },

    -- Enter the key tables below
    { key = "s", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
    {
      key = "a",
      mods = "LEADER",
      action = act.ActivateKeyTable({ name = "activate_pane", timeout_milliseconds = 1000 }),
    },
  },
  -- https://wezfurlong.org/wezterm/config/key-tables.html
  key_tables = {
    resize_pane = {
      { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
      { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
      { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
      { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },

      -- Cancel the mode by pressing escape or enter
      { key = "Enter", action = act.PopKeyTable },
      { key = "Escape", action = act.PopKeyTable },
    },
    activate_pane = {
      { key = "h", action = act.ActivatePaneDirection("Left") },
      { key = "l", action = act.ActivatePaneDirection("Right") },
      { key = "k", action = act.ActivatePaneDirection("Up") },
      { key = "j", action = act.ActivatePaneDirection("Down") },
    },
    copy_mode = {
      -- Motion
      { key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
      { key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
      { key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
      { key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
      -- Ends of the line: first non-blank, last non-blank, column zero
      { key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
      { key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
      { key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
      { key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
      { key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
      { key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
      -- Word motion
      { key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
      { key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
      { key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
      -- Jump to a character
      { key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
      { key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
      { key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
      { key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
      -- Ends of the scrollback
      { key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
      { key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
      -- Viewport
      { key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
      { key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
      { key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
      -- Scroll by page
      { key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
      { key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
      { key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
      { key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
      -- Selection mode
      { key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
      { key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
      { key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
      { key = "y", mods = "NONE", action = act.CopyTo("Clipboard") },

      -- Leave copy mode
      {
        key = "Enter",
        mods = "NONE",
        action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
      },
      { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
      { key = "c", mods = "CTRL", action = act.CopyMode("Close") },
      { key = "q", mods = "NONE", action = act.CopyMode("Close") },
    },
  },
}
