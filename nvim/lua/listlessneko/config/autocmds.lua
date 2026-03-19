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
