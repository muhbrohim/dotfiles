local wezterm = require("wezterm")

-- Configuration Table
local config = {}

-- 🎯 Startup: Open WSL2 & PowerShell in Separate Tabs
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window({ args = { "wsl.exe", "--cd", "~" } })
	window:spawn_tab({ args = { "pwsh.exe" } })
end)

-- 🖥️ Default Shell (WSL2 as Default)
-- config.default_prog = { "wsl.exe", "--cd", "~" }
config.default_prog = { "pwsh.exe" }

-- 🛠️ Launch Menu for Multiple Shells
config.launch_menu = {
	{ label = "WSL2 (Default)", args = { "wsl.exe", "--cd", "~" } },
	{ label = "PowerShell", args = { "pwsh.exe" } },
	{ label = "Command Prompt", args = { "cmd.exe" } },
}

-- 🎨 Font & Appearance
config.font = wezterm.font("JetBrains Mono")
config.font_size = 12.0
config.color_scheme = "Dracula"

-- 🪟 Window Settings
config.window_decorations = "RESIZE" -- Windows Terminal style
config.use_fancy_tab_bar = false -- Simple tab bar
config.tab_bar_at_bottom = false -- Tabs stay at the top
config.hide_tab_bar_if_only_one_tab = false -- Always show the tab bar

-- 🔲 Reduce Window Padding (Compact Look)
config.window_padding = { left = 5, right = 5, top = 5, bottom = 5 }

-- 🔢 Format Tab Titles (More Readable)
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	for i, t in ipairs(tabs) do
		if t.tab_id == tab.tab_id then
			return string.format("  [%d]  ", i) -- Adds padding for better readability
		end
	end
end)

-- ⌨️ Keybindings for Quick Tab Switching (Ctrl + Number)
config.keys = {}

for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CTRL",
		action = wezterm.action.ActivateTab(i - 1), -- Tabs are 0-indexed
	})
end

-- 🔧 Custom Keybindings for Pane Management
local custom_keys = {
	-- Split Panes
	{
		key = "v",
		mods = "CTRL|ALT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "h",
		mods = "CTRL|ALT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},

	-- Navigate Panes
	{
		key = "LeftArrow",
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "RightArrow",
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "UpArrow",
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "DownArrow",
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},

	-- Resize Panes
	{
		key = "LeftArrow",
		mods = "CTRL|ALT",
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "RightArrow",
		mods = "CTRL|ALT",
		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	},
	{
		key = "UpArrow",
		mods = "CTRL|ALT",
		action = wezterm.action.AdjustPaneSize({ "Up", 2 }),
	},
	{
		key = "DownArrow",
		mods = "CTRL|ALT",
		action = wezterm.action.AdjustPaneSize({ "Down", 2 }),
	},

	-- Close Pane with Confirmation
	{
		key = "q",
		mods = "CTRL|ALT",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},

	-- Optional: Toggle Full Screen
	{
		key = "f",
		mods = "CTRL|ALT",
		action = wezterm.action.ToggleFullScreen,
	},
}

-- Enter Copy Mode (Ctrl+Shift+c)
table.insert(config.keys, {
	key = "c",
	mods = "CTRL|SHIFT",
	action = wezterm.action.ActivateCopyMode,
})

-- Vim-like Copy Mode Keybindings
config.copy_mode = {
	key_bindings = {
		{ key = "q", mods = "CTRL", action = wezterm.action.CopyMode("SetSelectionModeBlock") },
		{ key = "h", mods = "NONE", action = wezterm.action.CopyMode("MoveLeft") },
		{ key = "l", mods = "NONE", action = wezterm.action.CopyMode("MoveRight") },
		{ key = "j", mods = "NONE", action = wezterm.action.CopyMode("MoveDown") },
		{ key = "k", mods = "NONE", action = wezterm.action.CopyMode("MoveUp") },

		{ key = "w", mods = "NONE", action = wezterm.action.CopyMode("MoveForwardWord") },
		{ key = "b", mods = "NONE", action = wezterm.action.CopyMode("MoveBackwardWord") },

		-- Vim-like character jumps
		{ key = "f", mods = "NONE", action = wezterm.action.CopyMode("JumpForward") },
		{ key = "F", mods = "NONE", action = wezterm.action.CopyMode("JumpBackward") },
		{ key = "t", mods = "NONE", action = wezterm.action.CopyMode("JumpForwardTill") },
		{ key = "T", mods = "NONE", action = wezterm.action.CopyMode("JumpBackwardTill") },

		{ key = "v", mods = "NONE", action = wezterm.action.CopyMode("SetSelectionModeCell") },

		{
			key = "y",
			mods = "NONE",
			action = wezterm.action.Multiple({
				wezterm.action.CopyTo("ClipboardAndPrimarySelection"),
				wezterm.action.ClearSelection,
				wezterm.action.CopyMode("Close"),
			}),
		},

		--		{ key = "q", mods = "NONE", action = wezterm.action.CopyMode("Close") },
		{ key = "Escape", mods = "NONE", action = wezterm.action.CopyMode("Close") },
	},
}

-- Merge Custom Keys
for _, key in ipairs(custom_keys) do
	table.insert(config.keys, key)
end

return config
