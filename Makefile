DOTFILES=~/.dotfiles/config

pacman-install-dev-packages:
	pacman -S - < ./scripts/pacman/dev-packages

pacman-install-gui-packages:
	pacman -S - < ./scripts/pacman/gui-packages

configure-all: configure-bash configure-git configure-i3 configure-nvim configure-terminal configure-tmux configure-X

configure-asdf:
	DOTFILES=$(DOTFILES) ./scripts/asdf/configure

configure-bash:
	DOTFILES=$(DOTFILES) ./scripts/bash/configure

configure-git:
	DOTFILES=$(DOTFILES) ./scripts/git/configure

configure-i3:
	DOTFILES=$(DOTFILES) ./scripts/i3/configure

configure-nvim:
	DOTFILES=$(DOTFILES) ./scripts/nvim/configure

configure-terminal:
	DOTFILES=$(DOTFILES) ./scripts/terminal/configure

configure-tmux:
	DOTFILES=$(DOTFILES) ./scripts/tmux/configure

configure-X:
	DOTFILES=$(DOTFILES) ./scripts/X/configure
