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

function pwd {
    command pwd | sed "s|^$HOME|~|"
}

alias ll="ls -la"
alias editprofile="nvim ~/.zshrc"
alias sourceprofile="source ~/.zshrc"
alias nvimconfig="~/.zshrc_scripts/nvimconfig.sh"
alias nvimtmux="nvim ~/.tmux.conf"
