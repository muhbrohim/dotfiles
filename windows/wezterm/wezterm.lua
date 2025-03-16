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
  { label = "Command Prompt", args = { "cmd.exe" } }
}

-- 🎨 Font & Appearance
config.font = wezterm.font("JetBrains Mono")
config.font_size = 12.0
config.color_scheme = "Dracula"

-- 🪟 Window Settings
config.window_decorations = "RESIZE" -- Windows Terminal style
config.use_fancy_tab_bar = false      -- Simple tab bar
config.tab_bar_at_bottom = false      -- Tabs stay at the top
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

return config

