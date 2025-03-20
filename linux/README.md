
## Stow

~/dotfiles/linux master*
❯ tree -a -L 3
.
├── bashrc
│   └── .bashrc
├── i3
│   └── .config
│       └── i3
├── picom
│   └── .config
│       └── picom
├── polybar
│   └── .config
│       └── polybar
├── README.md
├── rofi
│   └── .config
│       └── rofi
├── touchcursor
│   └── .config
│       └── touchcursor
├── wezterm
│   └── .config
│       └── wezterm
├── xremap
│   └── .config
│       └── xremap
└── zshrc
    └── .zshrc:


## zsh
cd ~/dotfiles/linux
stow -t ~ zshrc

## Notes
t ~ 	: tells Stow to place symlinks directly in your home directory (~). 
zshrc 	: Looks inside zshrc/ and sees .zshrc

Symlinks it to ~/.zshrc


