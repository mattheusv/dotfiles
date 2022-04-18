default: help;

configure-files: ## Setup the configuration files for all tools
	stow --target ~ h/

unconfigure-files: ## Remove the configuration files for all tools
	stow -D --target ~ h/

configure-arch-base: ## Install base tools to Arch Linux base installations
	./scripts/configure-base arch

configure-arch-dev: ## Install development tools to Arch Linux base installations
	./scripts/configure-dev arch

configure-deb-base: ## Install base tools to Debian base installations
	./scripts/configure-base deb

configure-deb-dev: ## Install development tools to Deb base installations
	./scripts/configure-dev deb

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
