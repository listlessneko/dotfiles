vim.g.mapleader = ' '

-- Move to Explore
-- vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

-- Navigate buffers
vim.keymap.set('n', '<Up>', ':bnext<CR>', {desc = 'Move to next buffer'})
vim.keymap.set('n', '<Down>', ':bprevious<CR>', {desc = 'Move to previous buffer'})

-- Move line(s) of code vertically. `:m` is the move command
vim.keymap.set('v', 'J', ':m \'>+1<CR>gv=gv')
vim.keymap.set('v', 'K', ':m \'<-2<CR>gv=gv')

-- Remap for dealing with visual line wraps
vim.keymap.set('n', 'j', 'v:count == 0 ? \'gj\': \'j\'', {expr = true})
vim.keymap.set('n', 'k', 'v:count == 0 ? \'gk\': \'k\'', {expr = true})

-- Exit on kj, kk, jj, and jk
vim.keymap.set('i', 'kj', '<Esc>', {desc = 'Exit insert mode'})
vim.keymap.set('i', 'kk', '<Esc>', {desc = 'Exit insert mode'})
vim.keymap.set('i', 'jj', '<Esc>', {desc = 'Exit insert mode'})
vim.keymap.set('i', 'jk', '<Esc>', {desc = 'Exit insert mode'})

-- Better indenting
vim.keymap.set('v', '<', '<gv', {desc = 'Indent left'})
vim.keymap.set('v', '>', '>gv', {desc = 'Indent right'})

-- Yank from cursor to eol
vim.keymap.set('n', 'Y', 'yg$', {desc = 'Yank from cursor to eol'})

-- Highlight entire file
vim.keymap.set('n', '<leader>a', 'ggVG', {desc = 'Highlight entire file'})

-- Keeps cursor in the same spot when joining current line to the next, scrolling up or down the page, or scrolling up and down a word search, respectively
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- "greatest remap ever." - The Prime Agen
-- Deletes highlighted word into the void register and then pastes it over. Keeps the previously copied (or yanked) word preserved for repeated pasting.
vim.keymap.set('x', '<leader>p', '"_dP', {desc = 'Maintains previously yanked word while deleting highlighted word'})

-- "next greatest remap ever : asbojornHaland" - The Prime Agen
-- To yank (or copy) to system clipboard,
-- Or to not yank to system clipboard (and yank to Neovim)?
-- That is the question.
vim.keymap.set('n', '<leader>y', '"+y', {desc = 'Yank to system'})
vim.keymap.set('v', '<leader>y', '"+y', {desc = 'Yank to system'})
vim.keymap.set('n', '<leader>Y', '"+Y', {desc = 'Yank to system'})

-- Delete to void register
vim.keymap.set('n', '<leader>d', '"_d', {desc = 'To the void!'})
vim.keymap.set('v', '<leader>d', '"_d', {desc = 'To the void!'})

-- Just don't do it.
vim.keymap.set('n', 'Q', '<nop>', {desc = 'Just don\'t do it.'})

-- Option to replace current word
vim.keymap.set('n', '<leader>re', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', {desc = 'Replace current word'})

-- increament/decrement numbers
vim.keymap.set('n', '<leader><C-a>', '<C-a>', {desc = 'Increment number'})
vim.keymap.set('n', '<leader><C-x>', '<C-x>', {desc = 'Decrement number'})

-- window management
vim.keymap.set('n', '<leader>wv', '<C-w>v', {desc = 'Split window vertically'})
vim.keymap.set('n', '<leader>wh', '<C-w>s', {desc = 'Split window horizontally'})
vim.keymap.set('n', '<leader>we', '<C-w>=', {desc = 'Make splits equal size'})
vim.keymap.set('n', '<leader>ww', '<cmd>close<CR>', {desc = 'Close current split'})

-- tab management
vim.keymap.set('n', '<leader>to', '<cmd>tabnew<CR>', {desc = 'Open new tab'})
vim.keymap.set('n', '<leader>tw', '<cmd>tabclose<CR>', {desc = 'Close current tab'})
vim.keymap.set('n', '<leader>tn', '<cmd>tabn<CR>', {desc = 'Go to next tab'})
vim.keymap.set('n', '<leader>tp', '<cmd>tabp<CR>', {desc = 'Go to previous tab'})
vim.keymap.set('n', '<leader>tf', '<cmd>tabnew %<CR>', {desc = 'Open current buffer in new tab'})

-- builtin search feature
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>', {silent = true,  desc = 'Disables highlighting after searching for word'})

-- Telescope
vim.keymap.set('n', '<leader>s', ':Telescope current_buffer_fuzzy_find<CR>', { desc = 'Search within current buffer'})

-- Run visual selection in Python
vim.keymap.set('v', '<leader>t', ':w !python3<CR>', { desc = 'Run selected Python code' })
