vim.g.mapleader = ' '

-- Navigate buffers
vim.keymap.set('n', '<Up>', ':bnext<CR>', { desc = 'Move to next buffer' })
vim.keymap.set('n', '<Down>', ':bprevious<CR>', { desc = 'Move to previous buffer' })

-- Buffer history navigation (like browser back/forward)
local buf_history = {}
local buf_history_pos = 0
local buf_navigating = false

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    if buf_navigating then return end
    local buf = vim.api.nvim_get_current_buf()
    if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= '' then return end
    -- Truncate any forward history when visiting a new buffer
    while #buf_history > buf_history_pos do
      table.remove(buf_history)
    end
    if buf_history[buf_history_pos] ~= buf then
      table.insert(buf_history, buf)
      buf_history_pos = #buf_history
    end
  end,
})

local function buf_history_nav(direction)
  local target = buf_history_pos + direction
  if target < 1 or target > #buf_history then return end
  buf_history_pos = target
  local buf = buf_history[buf_history_pos]
  if vim.api.nvim_buf_is_valid(buf) then
    buf_navigating = true
    vim.api.nvim_set_current_buf(buf)
    buf_navigating = false
  end
end

vim.keymap.set('n', '<Left>',  function() buf_history_nav(-1) end, { desc = 'Back in buffer history' })
vim.keymap.set('n', '<Right>', function() buf_history_nav(1) end,  { desc = 'Forward in buffer history' })

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

-- Window resize mode: press once, then h/j/k/l repeatedly; any other key exits
vim.keymap.set('n', '<C-w>m', function()
  vim.notify('Resize mode: h/l (width)  j/k (height)  <any> to exit', vim.log.levels.INFO)
  while true do
    local char = vim.fn.getcharstr()
    if     char == 'h' then vim.cmd('wincmd <')
    elseif char == 'l' then vim.cmd('wincmd >')
    elseif char == 'j' then vim.cmd('wincmd -')
    elseif char == 'k' then vim.cmd('wincmd +')
    else break
    end
    vim.cmd('redraw')
  end
end, { desc = 'Window resize mode' })

-- Clear search highlight
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>', { silent = true, desc = 'Clear search highlight' })

-- Exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
