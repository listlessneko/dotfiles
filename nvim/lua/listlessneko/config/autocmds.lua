-- Don't auto comment new line
vim.api.nvim_create_autocmd('BufEnter', {command = [[set formatoptions-=cro]]})

-- Highlight when yanking
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', {clear = true}),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Show cursor line only in active window
local cursorGrp = vim.api.nvim_create_augroup('CursorLine', {clear = true})
vim.api.nvim_create_autocmd({'InsertLeave', 'WinEnter'}, {
  pattern = '*',
  command = 'set cursorline',
  group = cursorGrp,
})
vim.api.nvim_create_autocmd(
{'InsertEnter', 'WinLeave'},
{pattern = '*', command = 'set nocursorline', group = cursorGrp}
)

-- Override vim-tmux-navigator's t-mode maps after all plugins load.
-- IsFZF() misfires for opencode (which spawns fzf subprocesses), passing keys
-- through to the terminal instead of navigating.
vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    vim.keymap.set('t', '<C-h>', '<C-\\><C-n>:TmuxNavigateLeft<CR>',  { desc = 'Navigate left' })
    vim.keymap.set('t', '<C-j>', '<C-\\><C-n>:TmuxNavigateDown<CR>',  { desc = 'Navigate down' })
    vim.keymap.set('t', '<C-k>', '<C-\\><C-n>:TmuxNavigateUp<CR>',    { desc = 'Navigate up' })
    vim.keymap.set('t', '<C-l>', '<C-\\><C-n>:TmuxNavigateRight<CR>', { desc = 'Navigate right' })
  end,
})

-- Keep line wrapping on in diff windows (Vim disables it by default when 'diff' is set)
vim.api.nvim_create_autocmd('OptionSet', {
  pattern = 'diff',
  callback = function()
    if vim.v.option_new == 'v:true' or vim.v.option_new == true then
      vim.wo.wrap = true
    end
  end,
})

-- Enable spell checking for certain file types
vim.api.nvim_create_autocmd(
{'BufRead', 'BufNewFile'},
  {
    pattern = {'*.txt', '*.md'},
    callback = function()
      vim.opt.spell = true
      vim.opt.spelllang = 'en'
    end,
  }
)
