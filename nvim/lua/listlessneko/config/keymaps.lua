vim.g.mapleader = ' '

-- Navigate buffers
vim.keymap.set('n', '<Up>', ':bnext<CR>', { desc = 'Move to next buffer' })
vim.keymap.set('n', '<Down>', ':bprevious<CR>', { desc = 'Move to previous buffer' })

-- Move line(s) of code vertically
vim.keymap.set('v', 'J', ':m \'>+1<CR>gv=gv')
vim.keymap.set('v', 'K', ':m \'<-2<CR>gv=gv')

-- Remap for dealing with visual line wraps
vim.keymap.set('n', 'j', 'v:count == 0 ? \'gj\': \'j\'', { expr = true })
vim.keymap.set('n', 'k', 'v:count == 0 ? \'gk\': \'k\'', { expr = true })

-- Exit insert mode
vim.keymap.set('i', 'kj', '<Esc>', { desc = 'Exit insert mode' })
vim.keymap.set('i', 'kk', '<Esc>', { desc = 'Exit insert mode' })
vim.keymap.set('i', 'jj', '<Esc>', { desc = 'Exit insert mode' })
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })

-- Better indenting
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right' })

-- Yank from cursor to eol
vim.keymap.set('n', 'Y', 'yg$', { desc = 'Yank from cursor to eol' })

-- Keep cursor in place when joining lines / scrolling / searching
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Disable ex mode
vim.keymap.set('n', 'Q', '<nop>', { desc = 'Disabled' })

-- Clear search highlight
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>', { silent = true, desc = 'Clear search highlight' })
