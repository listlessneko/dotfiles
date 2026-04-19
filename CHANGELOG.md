# Changelog

## 2026-04-19

### Neovim
- Upgraded Neovim from 0.10.0 to 0.11.7
- Migrated LSP config from deprecated `require('lspconfig')` framework to `vim.lsp.config` / `vim.lsp.enable` (Neovim 0.11 native API)
- Replaced `mason-lspconfig.setup_handlers` with direct `vim.lsp.config` + `vim.lsp.enable` calls
- Fixed hover border — moved from deprecated `vim.lsp.with` to passing border directly to `vim.lsp.buf.hover()`
- Fixed position encoding warning — replaced telescope LSP builtins (`gd`, `gr`, `gi`, `go`) with `vim.lsp.buf.*` equivalents
- Fixed deprecated diagnostic signs — replaced `vim.fn.sign_define` with `vim.diagnostic.config({ signs = { text = {...} } })`
- Fixed `vim.loop.fs_stat` → `vim.uv.fs_stat` in `lazy.lua`
- Fixed `vim.cmd('let g:netrw_liststyle = 3')` → `vim.g.netrw_liststyle = 3`
- Fixed `vim.cmd('autocmd ...')` in `vim-jsdoc.lua` → `vim.api.nvim_create_autocmd()`
- Removed redundant capabilities setup from `servers.lua`
- Added `clangd` LSP for C/C++
- Added opencode.nvim plugin (guarded — only loads when `opencode` binary is present)

### Tmux
- Added `Ctrl-h/j/k/l` keybindings for pane navigation (fix for Linux where vim-tmux-navigator wasn't installed)
- Added `~/.tmux/plugins/tpm/bin/install_plugins` to install script so plugins auto-install on new machines

### Install Script
- Made install script cross-platform (macOS and Linux)
- macOS: detects Intel vs Apple Silicon, uses `brew` for ripgrep and tmux
- Linux: uses `apt`, installs `xclip`
- Fixed Neovim asset name for 0.11+ (`nvim-linux-x86_64.tar.gz` / `nvim-macos-arm64.tar.gz`)
- Added `sudo rm -rf /opt/nvim` before reinstall to prevent stale binary

### Shell
- Fixed opencode PATH in `.bashrc` — now guarded with directory check and uses `$HOME` instead of hardcoded path
