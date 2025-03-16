
## Commands
    - New-Item -ItemType SymbolicLink -Path "$HOME\.config\wezterm\wezterm.lua" -Target "$HOME\dotfiles\windows\wezterm\wezterm.lua"



## Symlink the fodler - it's works

Remove-Item "$HOME\.config\wezterm" -Recurse -Force; New-Item -ItemType SymbolicLink -Path "$HOME\.config\wezterm" -Target "$HOME\dotfiles\windows\wezterm"



## Others
if (Test-Path "$HOME\.config\wezterm") { Remove-Item "$HOME\.config\wezterm" -Force } ; New-Item -ItemType SymbolicLink -Path "$HOME\.config\wezterm" -Target "$HOME\dotfiles\windows\wezterm"



### Zebar & Glazewm

Remove-Item "$HOME\.glzr\glazewm" -Recurse -Force; New-Item -ItemType SymbolicLink -Path "$HOME\.glzr\glazewm" -Target "$HOME\dotfiles\windows\glazewm"

Remove-Item "$HOME\.glzr\zebar" -Recurse -Force; New-Item -ItemType SymbolicLink -Path "$HOME\.glzr\zebar" -Target "$HOME\dotfiles\windows\zebar"
