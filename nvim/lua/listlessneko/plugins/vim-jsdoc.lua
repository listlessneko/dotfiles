return {
  'heavenshell/vim-jsdoc',
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "javascript", "typescript", "jsdoc" },
      callback = function() vim.cmd("syntax enable") end,
    })
  end
}
