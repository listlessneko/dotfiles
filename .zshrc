echo "Not a programmer..."
# Get current git branch
git_branch() {
  git symbolic-ref --short HEAD 2>/dev/null
}

# Only show branch if inside a git repo
git_prompt() {
  local branch
  branch=$(git_branch)
  if [ -n "$branch" ]; then
    echo " ($branch)"
  fi
}

setopt PROMPT_SUBST
export PROMPT='[%*] <%n> %1~/$(git_prompt) >> '
export EDITOR=nvim
export VISUAL=nvim

# Coder workspaces: SSH sessions deliver TZ via SendEnv (agent's embedded SSH server).
# Cache the value so non-SSH sessions (web terminal, IDE-spawned shells) can pick it up.
if [[ "$CODER" == "true" ]]; then
  if [[ -n "$TZ" ]]; then
    print -r -- "$TZ" > ~/.tz-from-client
  elif [[ -r ~/.tz-from-client ]]; then
    TZ=$(<~/.tz-from-client)
    export TZ
  fi
fi

# User-local scripts (bqvd, etc.)
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

function pwd {
    command pwd | sed "s|^$HOME|~|"
}

alias dotfiles="coder dotfiles https://github.com/listlessneko/dotfiles" 
alias ll="ls -la"
alias editprofile="nvim ~/.zshrc"
alias sourceprofile="source ~/.zshrc"
alias nvimconfig="~/.zshrc_scripts/nvimconfig.sh"
alias nvimtmux="nvim ~/.tmux.conf"
