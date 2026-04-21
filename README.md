# dotfiles

Personal dotfiles for macOS and Linux. Managed via symlinks from this repo.

## Supported Platforms

- Linux (Ubuntu/Debian) — primary daily driver
- macOS (Intel and Apple Silicon)

## What's Included

| Config | Description |
|--------|-------------|
| `.bashrc` | Shell config, aliases, git prompt, NVM, opencode PATH |
| `.tmux.conf` | Tmux config with TPM plugins, pane navigation, clipboard |
| `nvim/` | Neovim config built on lazy.nvim |

## Install

```bash
git clone git@github.com:listlessneko/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The install script handles both macOS and Linux. It will:
- Install ripgrep, Neovim 0.11.7, and tmux
- Install xclip (Linux only)
- Clone TPM and install tmux plugins
- Symlink nvim config, `.bashrc`, and `.tmux.conf`

## Neovim

Built on [lazy.nvim](https://github.com/folke/lazy.nvim). Requires Neovim 0.11+.

**Key plugins:**
- LSP via native `vim.lsp.config` API + `mason.nvim` (auto-installs language servers)
- Completion via `nvim-cmp` + `LuaSnip`
- Fuzzy finding via `telescope.nvim`
- File tree via `neo-tree.nvim`
- Syntax highlighting via `nvim-treesitter`
- Git integration via `gitsigns.nvim` + `lazygit.nvim` (lazygit optional)
- AI coding via `opencode.nvim` (Linux only, guarded by executable check)
- Theme: Catppuccin (custom colors)

**LSP servers auto-installed:**
`lua_ls`, `ts_ls`, `pyright`, `bashls`, `jsonls`, `yamlls`, `html`, `cssls`, `clangd`, `zls`, `terraformls`, `vimls`, `solidity_ls_nomicfoundation`

**Key keymaps:**

| Key | Action |
|-----|--------|
| `<leader>w` | Save |
| `<leader>f` | Find files (git-aware) |
| `<leader>sf` | Find files (CWD) |
| `<leader>sg` | Live grep |
| `<leader>ss` | Search current buffer |
| `<leader>o` | Open buffer picker |
| `<Up>` / `<Down>` | Next / prev buffer |

| Key | Action |
|-----|--------|
| `gd` | Goto definition |
| `gr` | Goto references |
| `K` | Hover documentation |
| `gl` | Open diagnostic float |
| `<leader>rn` | Rename symbol |
| `<leader>la` | Code action |
| `<leader>lf` | Format |
| `<leader>lw` | Diagnostics |

| Key | Action |
|-----|--------|
| `<leader>gg` | Open lazygit (if installed) |
| `<leader>g` | Git actions (blame, stage, diff, etc.) |
| `]h` / `[h` | Next / prev git hunk |
| `<leader>gs` | Stage hunk |
| `<leader>gb` | Blame line |
| `<leader>gd` | Diff vs HEAD |

| Key | Action |
|-----|--------|
| `<leader>y` / `<leader>Y` | Yank to system clipboard |
| `<leader>d` | Delete to void |
| `<leader>p` | Paste over selection (void delete) |
| `J` / `K` | Move selected lines down / up |
| `kj` / `jk` | Exit insert mode |

| Key | Action |
|-----|--------|
| `<leader>\|` | Vertical split |
| `<leader>-` | Horizontal split |
| `<leader>=` | Equalize splits |
| `<leader>x` | Close split |
| `<C-w>m` | Window resize mode (h/j/k/l, any key exits) |
| `<C-h/j/k/l>` | Navigate tmux/nvim panes |

## Tmux

Prefix: `Ctrl-a`

| Key | Action |
|-----|--------|
| `\|` | Split horizontal |
| `-` | Split vertical |
| `Ctrl-h/j/k/l` | Navigate panes |
| `prefix h/j/k/l` | Resize panes |
| `prefix r` | Reload config |

**Plugins:** vim-tmux-navigator, tmux-resurrect, tmux-continuum, tmux-themepack
