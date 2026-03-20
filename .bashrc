echo "Not a programmer..."

alias editprofile="nvim ~/.bashrc"
alias sourceprofile="source ~/.bashrc"

alias home="cd ~"
alias nvimconfig="cd ~/.config/nvim/ && nvim"
alias nvimghostty="cd ~/.config/ghostty/ && nvim"
alias nvimtmux="nvim ~/.tmux.conf"
alias workspace="cd ~/workspace/"

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History settings
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# Check window size after each command
shopt -s checkwinsize

# Common aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Load ~/.bash_aliases if it exists
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

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

export PS1='[\t] <\u> \W/$(git_prompt)>> '
export EDITOR=nvim
export VISUAL=nvim
