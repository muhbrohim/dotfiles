local wezterm = require("wezterm")
local catppuccin = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]

-- Configuration Table
local config = {}

-- 🖋️ Font & Appearance
config.font = wezterm.font("JetBrains Mono")
config.font_size = 18.0
config.color_scheme = "Dracula"

-- color_scheme = "Catppuccin Mocha"
-- colors = catppuccin -- Use built-in scheme directly
window_background_opacity = 0.95 -- Transparency level (0.0 to 1.0)
text_background_opacity = 0.9 -- Slight transparency for text
macos_window_background_blur = 30 -- Only applies if using macOS

-- 🪟 Window Settings
config.window_decorations = "RESIZE" -- Match Windows Terminal style
config.use_fancy_tab_bar = false -- Simple tab bar (Windows Terminal look)
config.tab_bar_at_bottom = false -- Keep tabs at the top
config.hide_tab_bar_if_only_one_tab = false -- Always show the tab bar

-- 🖼️ Reduce Window Padding (For a Compact Look)
config.window_padding = {
	left = 5,
	right = 5,
	top = 5,
	bottom = 5,
}

-- ⏳ Default Shell (Starts in PowerShell)
-- config.default_prog = { "pwsh.exe" }

-- 🔢 Format Tab Titles (More Readable, Adds Padding & Brackets)
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

return config
