# GOLANG ENVs
set -a PATH /usr/local/go/bin
if type -q go
    set -g GOBIN (go env GOPATH)/bin
    set -g GO111MODULE on
    set -a -g PATH $GOBIN
end

if type -q bat
    alias cat=bat
end

alias gs='git st'
alias gd='git df'
alias gl='git l'
alias gla='git last'
alias gpl='git pull'

source ~/.asdf/asdf.fish
source ~/.asdf/plugins/java/set-java-home.fish

# Python ENVs
set -a PATH $HOME/.local/bin

# Rust Envs
set -a PATH $HOME/.cargo/bin

# Node Envs
set -a PATH $HOME/.node/bin
set -a PATH $HOME/.npm/bin

# Mason installed servers
set -a PATH $HOME/.local/share/nvim/mason/bin

# Fzf
set -g FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border'

# git number bin
set -a PATH $HOME/.dotfiles/lib/git-number

# custom scripts
set -a PATH $HOME/.dotfiles/bin

# working scripts
set -a PATH $HOME/dev/work/bin

# Build from source binaries tools
set -a PATH $HOME/dev/tools/bin

# asdf
if test -e ~/.asdf/
    source $HOME/.asdf/asdf.fish
    source $HOME/.asdf/completions/asdf.fish
end

set -gx EDITOR 'nvim'

function git-search
    set commit (git log --oneline | fzf | cut -d ' ' -f1)
    if test -n "$commit"
        git show $commit
    end
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

function gbr --description "Git browse commits"
    set -l log_line_to_hash "echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
    set -l view_commit "$log_line_to_hash | xargs -I % sh -c 'git show --color=always % | delta | less -R'"

    git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
    fzf --ansi --no-sort --reverse --multi --preview="$view_commit" \
    | cut -d ' ' -f3 | read -lz commit
    commandline -i -- (echo $commit | grep -o "[a-f0-9]\{7,\}")

end

function switch_git_worktree
    set selected_path (git worktree list | fzf | awk '{print $1}')
    if test -n "$selected_path"
        cd "$selected_path"
        commandline -f repaint
    end
end

bind \cg gbr

bind \cw switch_git_worktree
