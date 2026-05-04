#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname)"
NVIM_VERSION="v0.11.7"
LAZYGIT_VERSION="0.61.1"

# Populate GitHub's SSH host keys before any git operations
mkdir -p ~/.ssh
curl -s https://api.github.com/meta | python3 -c "import sys,json; [print(f'github.com {k}') for k in json.load(sys.stdin)['ssh_keys']]" > ~/.ssh/known_hosts

if [[ "$OS" == "Darwin" ]]; then
  ARCH="$(uname -m)"
  if [[ "$ARCH" == "arm64" ]]; then
    NVIM_ASSET="nvim-macos-arm64"
  else
    NVIM_ASSET="nvim-macos-x86_64"
  fi

  # Install ripgrep
  if ! command -v rg &> /dev/null; then
    brew install ripgrep
  fi

  # Install Neovim
  if ! command -v nvim &> /dev/null || [[ $(nvim --version | head -1) != *"$NVIM_VERSION"* ]]; then
    curl -LO "https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/$NVIM_ASSET.tar.gz"
    tar -xzf "$NVIM_ASSET.tar.gz"
    sudo mv "$NVIM_ASSET" /opt/nvim
    sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
    rm "$NVIM_ASSET.tar.gz"
  fi

  # Install tmux
  if ! command -v tmux &> /dev/null || [[ $(tmux -V) != *"3.5a"* ]]; then
    brew install tmux
  fi

  # Install lazygit
  if ! command -v lazygit &> /dev/null || [[ $(lazygit --version) != *"$LAZYGIT_VERSION"* ]]; then
    curl -LO "https://github.com/jesseduffield/lazygit/releases/download/v$LAZYGIT_VERSION/lazygit_${LAZYGIT_VERSION}_Darwin_${ARCH}.tar.gz"
    tar xf "lazygit_${LAZYGIT_VERSION}_Darwin_${ARCH}.tar.gz" lazygit
    sudo install lazygit /usr/local/bin/
    rm "lazygit_${LAZYGIT_VERSION}_Darwin_${ARCH}.tar.gz" lazygit
  fi

  # Install visidata
  if ! command -v vd &> /dev/null; then
    brew install visidata
  fi

else
  # Install ripgrep
  if ! command -v rg &> /dev/null; then
    sudo apt install -y ripgrep
  fi

  # Install Neovim
  if ! command -v nvim &> /dev/null || [[ $(nvim --version | head -1) != *"$NVIM_VERSION"* ]]; then
    curl -LO "https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/nvim-linux-x86_64.tar.gz"
    tar -xzf nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim
    sudo mv nvim-linux-x86_64 /opt/nvim
    sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
    rm nvim-linux-x86_64.tar.gz
  fi

  # Install tmux
  if ! command -v tmux &> /dev/null || [[ $(tmux -V) != *"3.5a"* ]]; then
    sudo apt install -y tmux
  fi

  # Install xclip
  if ! command -v xclip &> /dev/null; then
    sudo apt install -y xclip
  fi

  # Install lazygit
  if ! command -v lazygit &> /dev/null || [[ $(lazygit --version) != *"$LAZYGIT_VERSION"* ]]; then
    curl -LO "https://github.com/jesseduffield/lazygit/releases/download/v$LAZYGIT_VERSION/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf "lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" lazygit
    sudo install lazygit /usr/local/bin/
    rm "lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" lazygit
  fi

  # Install visidata (via pipx for an isolated user-level install)
  if ! command -v vd &> /dev/null; then
    if ! command -v pipx &> /dev/null; then
      sudo apt install -y --no-install-recommends pipx
      pipx ensurepath
    fi
    pipx install visidata
  fi
fi

# Symlink nvim config
rm -rf ~/.config/nvim
ln -sf "$DOTFILES_DIR/nvim" ~/.config/nvim

# Symlink bashrc
ln -sf "$DOTFILES_DIR/.bashrc" ~/.bashrc

# Symlink zshrc
ln -sf "$DOTFILES_DIR/.zshrc" ~/.zshrc

# Symlink visidata config
ln -sf "$DOTFILES_DIR/.visidatarc" ~/.visidatarc

# Install TPM
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install tmux plugins
~/.tmux/plugins/tpm/bin/install_plugins

# Symlink tmux config
ln -sf "$DOTFILES_DIR/.tmux.conf" ~/.tmux.conf

# Symlink tmux scripts
mkdir -p ~/.tmux/scripts
ln -sf "$DOTFILES_DIR/tmux/main-vertical-right.sh" ~/.tmux/scripts/main-vertical-right.sh

# Symlink user scripts (bqvd, etc.) into ~/.local/bin
mkdir -p ~/.local/bin
for script in "$DOTFILES_DIR"/bin/*; do
  [ -f "$script" ] && ln -sf "$script" ~/.local/bin/"$(basename "$script")"
done
