# Dotfiles

This repository contains my personal dotfiles for a minimal, keyboard-driven Linux setup using i3, Neovim, and other lightweight tools.

## Structure~/dotfiles master
❯ tree -a -L 2
.
├── .git
│   ├── branches
│   ├── COMMIT_EDITMSG
│   ├── config
│   ├── description
│   ├── HEAD
│   ├── hooks
│   ├── index
│   ├── info
│   ├── logs
│   ├── objects
│   └── refs
├── .gitignore
├── i3
│   └── .config
├── nvim
│   └── .config
├── picom
│   └── .config
├── polybar
│   └── .config
├── rofi
│   └── .config
├── touchcursor
│   └── .config
├── wezterm
│   └── .config
├── xremap
│   └── .config
└── zshrc
    └── .zshrc
```
.
├── i3/.config
├── nvim/.config
├── picom/.config
├── polybar/.config
├── rofi/.config
├── touchcursor/.config
├── wezterm/.config
├── xremap/.config
├── zshrc/.zshrc
```

## Installation
To set up these dotfiles on a new system:

```sh
# Clone the repository
git clone --recursive https://github.com/yourusername/dotfiles.git ~/dotfiles

# Use GNU Stow to manage dotfiles
cd ~/dotfiles
stow i3 nvim picom polybar rofi touchcursor wezterm xremap zshrc
```

## Included Tools
- **i3** - Tiling window manager
- **Neovim** - Text editor
- **Picom** - Compositor
- **Polybar** - Status bar
- **Rofi** - Application launcher
- **WezTerm** - Terminal emulator
- **Zsh** - Shell with Powerlevel10k
- **GNU Stow** - Symlink manager for dotfiles

## Notes
- Ensure you have dependencies installed for each tool before applying the configurations.
- Backup existing dotfiles before replacing them.

## License
This repository is open-source. Use at your own risk.

---
Happy hacking! 🚀

