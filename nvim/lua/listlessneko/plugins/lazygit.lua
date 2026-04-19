return {
  "kdheepak/lazygit.nvim",
  enabled = vim.fn.executable("lazygit") == 1,
  cmd = { "LazyGit", "LazyGitCurrentFile", "LazyGitFilter" },
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
  },
}
