DOTFILES=~/.dotfiles/config


default: help;

pacman-install-dev-packages: ## Install dev packages
	pacman -S - < ./scripts/pacman/dev-packages

pacman-install-gui-packages: ## Install gui packages
	pacman -S - < ./scripts/pacman/gui-packages

configure-all: ## Configure all configs
	configure-bash configure-git configure-nvim configure-terminal configure-tmux configure-X

configure-asdf: ## Configure and install languages
	DOTFILES=$(DOTFILES) ./scripts/asdf/configure

configure-bash: ## Configure bash config files
	DOTFILES=$(DOTFILES) ./scripts/bash/configure

configure-git: ## Configure git config files
	DOTFILES=$(DOTFILES) ./scripts/git/configure

configure-nvim: ## Configure neovim config files
	DOTFILES=$(DOTFILES) ./scripts/nvim/configure

configure-terminal: ## Configure terminal config files
	DOTFILES=$(DOTFILES) ./scripts/terminal/configure

configure-tmux: ## Configure tmux config files
	DOTFILES=$(DOTFILES) ./scripts/tmux/configure

configure-X: ## Configure X server file
	DOTFILES=$(DOTFILES) ./scripts/X/configure

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
