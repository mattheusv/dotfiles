DOTFILES=~/.dotfiles/config


default: help;

configure-arch-base: ## Install and configure base tools to Arch Linux base installations
	@DOTFILES=$(DOTFILES) ./scripts/configure-base arch

configure-arch-dev: ## Install and configure development tools to Arch Linux base installations
	@DOTFILES=$(DOTFILES) ./scripts/configure-dev arch

configure-deb-base: ## Install and configure base tools to Debian base installations
	@DOTFILES=$(DOTFILES) ./scripts/configure-base deb

configure-deb-dev: ## Install and configure development tools to Deb base installations
	@DOTFILES=$(DOTFILES) ./scripts/configure-dev deb

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
