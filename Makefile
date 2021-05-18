DOTFILES=~/.dotfiles/config


default: help;

configure-base: ## Install and configure base tools
	@DOTFILES=$(DOTFILES) ./scripts/configure-base

configure-dev: ## Install and configure development tools
	@DOTFILES=$(DOTFILES) ./scripts/configure-dev

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
