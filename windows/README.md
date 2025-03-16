
## Commands
    - New-Item -ItemType SymbolicLink -Path "$HOME\.config\wezterm\wezterm.lua" -Target "$HOME\dotfiles\windows\wezterm\wezterm.lua"



## Symlink the fodler - it's works

Remove-Item "$HOME\.config\wezterm" -Recurse -Force; New-Item -ItemType SymbolicLink -Path "$HOME\.config\wezterm" -Target "$HOME\dotfiles\windows\wezterm"



## Others
if (Test-Path "$HOME\.config\wezterm") { Remove-Item "$HOME\.config\wezterm" -Force } ; New-Item -ItemType SymbolicLink -Path "$HOME\.config\wezterm" -Target "$HOME\dotfiles\windows\wezterm"

