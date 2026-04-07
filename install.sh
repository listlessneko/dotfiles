#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Populate GitHub's SSH host keys before any git operations
mkdir -p ~/.ssh
curl -s https://api.github.com/meta | python3 -c "import sys,json; [print(f'github.com {k}') for k in json.load(sys.stdin)['ssh_keys']]" > ~/.ssh/known_hosts

# Install ripgrep
if ! command -v rg &> /dev/null; then
  sudo apt install -y ripgrep
fi

# Install Neovim 0.10.0
if ! command -v nvim &> /dev/null || [[ $(nvim --version | head -1) != *"v0.10.0"* ]]; then
  curl -LO https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-linux64.tar.gz
  tar -xzf nvim-linux64.tar.gz
  sudo mv nvim-linux64 /opt/nvim
  sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
  rm nvim-linux64.tar.gz
fi

# Symlink nvim config
rm -rf ~/.config/nvim
ln -sf "$DOTFILES_DIR/nvim" ~/.config/nvim

# Symlink bashrc
ln -sf "$DOTFILES_DIR/.bashrc" ~/.bashrc

# Install tmux 3.5a
if ! command -v tmux &> /dev/null || [[ $(tmux -V) != *"3.5a"* ]]; then
  sudo apt install -y tmux
fi

# Install xclip
if ! command -v xclip &> /dev/null; then
  sudo apt install -y xclip
fi

# Install TPM
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install tmux plugins
~/.tmux/plugins/tpm/bin/install_plugins

# Symlink tmux config
ln -sf "$DOTFILES_DIR/.tmux.conf" ~/.tmux.conf
