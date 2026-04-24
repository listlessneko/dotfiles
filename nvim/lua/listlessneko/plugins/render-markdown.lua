return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = { "markdown" },
  config = function()
    require("render-markdown").setup({
      completions = { lsp = { enabled = true } },
      heading = {
        icons = { "➤ ", "➣ ", "➢ ", "➛ ", "➙ ", "➝ " },
        width = "block",
        left_pad = 0,
        right_pad = 0,
      },
    })

    local function set_heading_hl()
      local bg = "#32302f" -- gruvbox bg1 hard
      local fg = "#d8a657" -- gruvbox yellow
      for i = 1, 6 do
        vim.api.nvim_set_hl(0, "RmH" .. i .. "Bg", { bg = bg })
        vim.api.nvim_set_hl(0, "RmH" .. i, { fg = fg, bg = bg, bold = true })
        vim.api.nvim_set_hl(0, "RmH" .. i .. "Sign", { fg = fg })
        vim.api.nvim_set_hl(0, "@markup.heading." .. i .. ".markdown", { fg = fg, bg = bg, bold = true })
        vim.api.nvim_set_hl(0, "@markup.heading." .. i, { fg = fg, bg = bg, bold = true })
      end
    end

    set_heading_hl()
    vim.api.nvim_create_autocmd({ "ColorScheme", "FileType" }, {
      pattern = { "*", "markdown" },
      callback = set_heading_hl,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.opt_local.conceallevel = 2
      end,
    })
  end,
}
