vim.cmd('let g:netrw_liststyle = 3')
vim.g.have_nerd_font = true

vim.opt.title = true -- set the title of window to the value of the titlestring
vim.opt.confirm = true -- confirm to save changes before exiting modified buffer

vim.opt.guicursor = 'n-v-i-c:block-Cursor' -- set cursor shape
vim.opt.cursorline = true -- highlight the current line
vim.opt.number = true -- show numbers
vim.opt.relativenumber = true -- show relative numbers
vim.opt.scrolloff = 8 -- Makes sure there are always eight lines of context
vim.opt.sidescrolloff = 8 -- Makes sure there are always eight lines of context
vim.opt.showmode = false -- disables showing mode in command line

vim.opt.undofile = true -- enable persistent undo
vim.opt.backup = false -- disables backup file
vim.opt.swapfile = false -- disables swapfile
vim.opt.writebackup = false -- if a file is being edited by anotehr program  (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.updatetime = 100 -- faster completion (4000ms default)
vim.opt.timeoutlen = 200 -- decrease mapped sequence wait time; displays which-key popup sooner

vim.opt.mouse = 'a' -- allow the mouse to be used in neovim
vim.opt.list = true -- allows list option
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- sets characters for the coresponding keys

-- tabs and indentation
-- vim.opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
vim.opt.shiftwidth = 2 -- 2 spaces for indent width
vim.opt.expandtab = true -- expand tab to spaces
vim.opt.autoindent = true -- copy indent from current line when starting new one
vim.opt.breakindent = true -- wrap lines with indent
vim.opt.smartindent = true -- make indenting smarter again
vim.opt.backspace = 'indent,eol,start' -- allow backspace on indent, end of line or insert mode start position
vim.opt.wrap = true -- disables line wrapping
vim.opt.ruler = false -- disables ruler

-- search settings
vim.opt.hlsearch = true -- highlight all matches on previous search pattern
vim.opt.incsearch = true -- make search act like search in modern browser
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive
vim.opt.inccommand = 'split' -- preview substitutions live

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
vim.opt.termguicolors = true
vim.opt.background = 'dark' -- colorschemes that can belight or dark will be made dark

vim.opt.signcolumn = 'yes' -- show sign column so that text doesn't shift

-- windows and tabs
vim.opt.splitright = true -- split vertical window to the right
vim.opt.splitbelow = true -- spl.it horizontal window to the bottom
vim.opt.showtabline = 0 -- always show tabs
