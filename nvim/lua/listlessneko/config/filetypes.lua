-- Smite rules (~/smite-rules/**/*.sml) are a Python-syntax DSL, not Standard ML.
-- Give them their own filetype so pyright doesn't attach, but highlight with
-- the Python treesitter parser.
vim.filetype.add({
  pattern = {
    ['.*/smite%-rules/.*%.sml'] = 'smite',
  },
})
vim.treesitter.language.register('python', 'smite')

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'smite',
  group = vim.api.nvim_create_augroup('smite-filetype', {clear = true}),
  callback = function()
    vim.bo.commentstring = '# %s'
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.expandtab = true
  end,
})
