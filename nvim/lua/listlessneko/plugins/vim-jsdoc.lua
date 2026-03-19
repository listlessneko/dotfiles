return {
  'heavenshell/vim-jsdoc',
  config = function()
    vim.cmd('autocmd FileType javascript,typescript,jsdoc syntax enable')
  end
}
