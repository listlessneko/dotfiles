return {
  { "]h", "<cmd>lua require('gitsigns').next_hunk()<cr>", desc = "Next hunk" },
  { "[h", "<cmd>lua require('gitsigns').prev_hunk()<cr>", desc = "Prev hunk" },
  { "ih", ":<C-U>Gitsigns select_hunk<CR>", desc = "Select hunk", mode = { "o", "x" } },
  { "g", group = { name = "Go To" } },
}
-- return {
--   g = {
--     name = "Go To",
--     d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Goto definition" },
--     D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Goto declaration" },
--     i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Goto implementation" },
--     l = { "<cmd>lua vim.diagnostic.open_float()<cr>", "Goto float diagnostics" },
--     o = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Goto type definition" },
--     r = { "<cmd>lua vim.lsp.buf.references()<cr>", "Goto references" },
--   },
-- }
-- return {
--   { "", group = "Go To" },
--   { "", "gd", desc = "<cmd>lua vim.lsp.buf.definition()<cr>" },
--   { "", "go", desc = "<cmd>lua vim.lsp.buf.type_definition()<cr>" },
--   { "", "gr", desc = "<cmd>lua vim.lsp.buf.references()<cr>" },
--   { "", "gl", desc = "<cmd>lua vim.diagnostic.open_float()<cr>" },
--   { "", "gD", desc = "<cmd>lua vim.lsp.buf.declaration()<cr>" },
--   { "", "gi", desc = "<cmd>lua vim.lsp.buf.implementation()<cr>" },
-- }
