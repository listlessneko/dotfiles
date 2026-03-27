#!/bin/bash

#Install ripgrep
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
ln -sf ~/.config/coderv2/dotfiles/nvim ~/.config/nvim

# Symlink bashrc
ln -sf ~/.config/coderv2/dotfiles/.bashrc ~/.bashrc

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

# Symlink tmux config
ln -sf ~/.config/coderv2/dotfiles/.tmux.conf ~/.tmux.conf
