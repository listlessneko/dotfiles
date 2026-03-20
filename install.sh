#!/bin/bash
# Install Neovim 0.10.0 if not already installed or wrong version
if ! command -v nvim &> /dev/null || [[ $(nvim --version | head -1) != *"v0.10.0"* ]]; then
  curl -LO https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-linux64.tar.gz
  tar -xzf nvim-linux64.tar.gz
  sudo mv nvim-linux64 /opt/nvim
  sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
  rm nvim-linux64.tar.gz
fi

# Symlink nvim config
ln -sf ~/.config/coderv2/dotfiles/nvim ~/.config/nvim
