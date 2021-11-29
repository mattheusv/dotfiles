# dotfiles

This repo contains my personalized config files for neovim, fish, tmux and alacritty (and potentially others in the future).

I generally always use systems based on Debian or Arch Linux, so there are installation and configuration scripts for both.

The configuration is split between `base` and `dev`. Base installs and configures basic packages to use like browser, 
terminal, git, tmux, etc. Dev installs and configures development packages like neovim, gcc, make, cmake, docker, etc.

## Installation
  ```
  git clone https://github.com/msalcantara/dotfiles --recurse-submodules $HOME/.dotfiles 

  cd ~/.dotfiles

  make
  ```

Probably this will never be interesting for anyone who isn't me, but you never know. Feel free to copy what you like.
