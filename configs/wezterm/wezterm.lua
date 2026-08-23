local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.audible_bell = "SystemBeep"
config.font = wezterm.font_with_fallback({
	"GeistMono Nerd Font",
	"Hiragino Sans",
})
config.font_size = 12.0
config.use_ime = true
config.window_background_opacity = 0.85
config.macos_window_background_blur = 10
config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.5,
}

config.color_scheme = "Kanagawa Dragon (Gogh)"

----------------------------------------------------
-- Tab
----------------------------------------------------
-- タイトルバーを非表示
config.window_decorations = "RESIZE"
-- タブバーの表示
config.show_tabs_in_tab_bar = true
-- タブが一つでも常に表示
config.hide_tab_bar_if_only_one_tab = false
-- falseにするとタブバーの透過が効かなくなる
-- config.use_fancy_tab_bar = false

-- タブバーの透過
config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}

-- タブバーを背景色に合わせる
config.window_background_gradient = {
	colors = { "#000000" },
}

-- タブの追加ボタンを非表示
config.show_new_tab_button_in_tab_bar = false
-- nightlyのみ使用可能
-- タブの閉じるボタンを非表示
config.show_close_tab_button_in_tabs = false

-- ハイパーリンクルール（デフォルト + カスタム）
config.hyperlink_rules = wezterm.default_hyperlink_rules()
-- GitHub issue/PR: owner/repo#123
table.insert(config.hyperlink_rules, {
	regex = [[\b([A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+)#(\d+)\b]],
	format = "https://github.com/$1/issues/$2",
})

-- タブ同士の境界線を非表示
config.colors = {
	tab_bar = {
		inactive_tab_edge = "none",
	},
	cursor_bg = "#e8874a",
	cursor_fg = "#ffffff",
	cursor_border = "#e8874a",
}

-- カーソルスタイル
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 530

-- タブの形をカスタマイズ
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_left_half_circle_thick
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_right_half_circle_thick

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local raw_title = tab.active_pane.title

	-- Claude Code 判定
	local is_claude = raw_title:find("Claude Code") ~= nil
	-- スピナー検出（アイコンが ✳ 以外ならスピナー＝考え中）
	local icon = raw_title:match("^(%S+)")
	local is_thinking = is_claude and icon and icon ~= "✳" and icon ~= "❯"

	local background = "#333333"
	local foreground = "#999999"
	local edge_background = "none"
	if is_thinking and tab.is_active then
		background = "#ffffff"
		foreground = "#333333"
	elseif tab.is_active then
		background = "#e8874a"
		foreground = "#ffffff"
	end
	local edge_foreground = background
	local title = "   " .. wezterm.truncate_right(raw_title, max_width - 1) .. "   "
	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)


----------------------------------------------------
-- Command Palette: vde-layout プリセット
----------------------------------------------------
wezterm.on("augment-command-palette", function(window, pane)
	return {
		{
			brief = "nzm: Dev (nvim + Claude + Terminal x2)",
			icon = "cod_layout",
			action = wezterm.action_callback(function(window, pane)
				pane:send_text("vde-layout dev --currentWindow\n")
			end),
		},
		{
			brief = "nzm: Dev (Cursor + Claude + Term split)",
			icon = "cod_layout",
			action = wezterm.action_callback(function(window, pane)
				pane:send_text("nzm-cursor-split dev\n")
			end),
		},
		{
			brief = "nzm: Workspace (nvim + Claude + Terminal)",
			icon = "cod_layout",
			action = wezterm.action_callback(function(window, pane)
				pane:send_text("cd ~/dotfiles && vde-layout ws --currentWindow\n")
			end),
		},
		{
			brief = "nzm: Workspace (Cursor + Claude + Term split, ~/dotfiles)",
			icon = "cod_layout",
			action = wezterm.action_callback(function(window, pane)
				pane:send_text("nzm-cursor-split ws\n")
			end),
		},
	}
end)

----------------------------------------------------
-- keybinds
----------------------------------------------------
config.disable_default_key_bindings = true
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

return config
