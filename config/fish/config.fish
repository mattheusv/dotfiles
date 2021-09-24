# GOLANG ENVs
if type -q go
    set -a PATH /usr/local/go/bin
    set -g GOBIN (go env GOPATH)/bin
    set -g GO111MODULE on
    set -a -g PATH $GOBIN
end

# Python ENVs
set -a PATH $HOME/.local/bin

# Rust Envs
set -a PATH $HOME/.cargo/bin

# Fzf
set -g FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border'

# git number bin
set -a PATH $HOME/.dotfiles/lib/git-number

# asdf
if test -e ~/.asdf/
    source $HOME/.asdf/asdf.fish
    source $HOME/.asdf/completions/asdf.fish
end

function fish_prompt
    if test -n "$SSH_TTY"
        echo -n (set_color brred)"$USER"(set_color white)'@'(set_color yellow)(prompt_hostname)' '
    end

    echo -n (set_color blue)(prompt_pwd)' '
    echo -n (set_color --bold)(fish_git_prompt)' '

    set_color -o
    if test "$USER" = 'root'
        echo -n (set_color red)'# '
    end
    echo -n (set_color red)'❯'(set_color yellow)'❯'(set_color green)'❯ '
    set_color normal
end

function fish_user_key_bindings
  # ctrl-del
  bind \e\[3\;5~ kill-word

  # Configure fzf bindings
  if test -e ~/.fzf/shell/key-bindings.fish
    source ~/.fzf/shell/key-bindings.fish  
  end
  if type fzf_key_bindings &> /dev/null
      fzf_key_bindings
  end

  # Load bindings to specific machines
  if functions -q local_bindings
		local_bindings
	end
end

function fish_greeting
end

# https://github.com/fish-shell/fish-shell/issues/7841
function fish_command_not_found
    __fish_default_command_not_found_handler $argv
end
