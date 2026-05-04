# dotfiles

Personal dotfiles for macOS and Linux. Managed via symlinks from this repo.

## Supported Platforms

- Linux (Ubuntu/Debian) — primary daily driver
- macOS (Intel and Apple Silicon)

## What's Included

| Config | Description |
|--------|-------------|
| `.bashrc` | Shell config, aliases, git prompt, NVM, opencode PATH |
| `.zshrc` | Zsh config, PATH setup, dotfiles alias |
| `.tmux.conf` | Tmux config with TPM plugins, pane navigation, clipboard |
| `nvim/` | Neovim config built on lazy.nvim |
| `bin/bqvd` | BigQuery → visidata pipeline script |
| `.visidatarc` | Visidata theme and settings |

## Install

```bash
git clone git@github.com:listlessneko/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The install script handles both macOS and Linux. It will:
- Install ripgrep, Neovim 0.11.7, tmux, and lazygit (pinned release)
- Install xclip (Linux only)
- Install visidata via pipx (Linux only)
- Clone TPM and install tmux plugins
- Symlink nvim config, `.bashrc`, `.zshrc`, `.tmux.conf`, `.visidatarc`, and `bin/*`
- Forward client timezone on Coder workspaces (gated on `$CODER=true`)

## Neovim

Built on [lazy.nvim](https://github.com/folke/lazy.nvim). Requires Neovim 0.11+.

**Key plugins:**
- LSP via native `vim.lsp.config` API + `mason.nvim` (auto-installs language servers)
- Completion via `nvim-cmp` + `LuaSnip`
- Fuzzy finding via `telescope.nvim`
- File tree via `neo-tree.nvim`
- Syntax highlighting via `nvim-treesitter`
- In-buffer markdown rendering via `render-markdown.nvim`
- Git integration via `gitsigns.nvim` + `lazygit.nvim` + `diffview.nvim`
- Debugging via `nvim-dap` + `nvim-dap-ui` + `nvim-dap-virtual-text` (codelldb adapter for C/C++/Rust)
- Terminal management via `toggleterm.nvim` (float + horizontal split, persistent sessions)
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
| `<Up>` / `<Down>` | Next / prev buffer (by number) |
| `<Left>` / `<Right>` | Back / forward in buffer history |

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
| `<leader>gg` | Open lazygit |
| `]h` / `[h` | Next / prev git hunk |
| `<leader>gs` | Stage hunk |
| `<leader>gb` | Blame line |
| `<leader>gd` | Diff vs HEAD (diffview) |
| `<leader>gh` | File history (diffview) |
| `<leader>gL` | Last commit (diffview) |
| `<leader>gP` | Arbitrary range diff (diffview) |
| `<leader>gQ` | Close diffview |

| Key | Action |
|-----|--------|
| `<leader>rc` | Replace word under cursor (confirm each) |
| `<leader>rs` | Replace selection in file (confirm each) |
| `<leader>rr` | Replace within visual selection (confirm each) |

| Key | Action |
|-----|--------|
| `af` / `if` | Around / inside function |
| `ai` / `ii` | Around / inside conditional (if, switch) |
| `al` / `il` | Around / inside loop |
| `ap` / `ip` | Around / inside parameter |

| Key | Action |
|-----|--------|
| `<leader>y` / `<leader>Y` | Yank to system clipboard |
| `<leader>d` | Delete to void |
| `<leader>p` | Paste over selection (void delete) |
| `<leader>Qr` | Run buffer/selection in bqvd (BigQuery) |
| `J` / `K` | Move selected lines down / up |
| `kj` / `jk` | Exit insert mode |

| Key | Action |
|-----|--------|
| `<leader>Dc` / `<F5>` | Start / continue |
| `<leader>Db` | Toggle breakpoint |
| `<leader>DB` | Conditional breakpoint |
| `<leader>Dn` / `<F10>` | Step over |
| `<leader>Di` / `<F11>` | Step into |
| `<leader>Do` / `<F12>` | Step out |
| `<leader>De` | Evaluate expression |
| `<leader>Du` | Toggle debug UI |
| `<leader>Dq` | Terminate |

| Key | Action |
|-----|--------|
| `<leader>\|` | Vertical split |
| `<leader>-` | Horizontal split |
| `<leader>=` | Equalize splits |
| `<leader>x` | Close split |
| `<C-w>m` | Window resize mode (h/j/k/l, any key exits) |
| `<C-h/j/k/l>` | Navigate tmux/nvim panes |

| Key | Action |
|-----|--------|
| `<C-t>` | Toggle float terminal |
| `<leader>tf` | Float terminal |
| `<leader>t-` | Horizontal split terminal |
| `<leader>t\|` | Vertical split terminal (toggle) |
| `<leader>tl` | List all buffers/terminals |
| `<Esc><Esc>` | Exit terminal mode (keep window) |

## Tmux

Prefix: `Ctrl-Space`

| Key | Action |
|-----|--------|
| `\|` | Split horizontal |
| `-` | Split vertical |
| `Ctrl-h/j/k/l` | Navigate panes |
| `prefix h/j/k/l` | Resize panes |
| `prefix r` | Reload config |
| `M-1` .. `M-5` | Inverse main-vertical layout presets |

**Plugins:** vim-tmux-navigator, tmux-resurrect, tmux-continuum, tmux-themepack
