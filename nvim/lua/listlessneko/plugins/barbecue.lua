-- Winbar that uses nvim-navic in order to get LSP context
return {

  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      -- configurations go here
    },
    config = function()
      require('barbecue').setup({
        create_autocmd = false,
      })
      vim.api.nvim_create_autocmd({
       'WinScrolled',
       'BufWinEnter',
       'CursorHold',
       'InsertLeave',

       -- include this if you have set `show_modified` to `true`
       -- 'BufModifiedSet',
      }, {
        group = vim.api.nvim_create_augroup('barbecue.updater', {}),
        callback = function()
          require('barbecue.ui').update()
        end,
      })
    end,
  }

}
