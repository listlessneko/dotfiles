return {
  { "g", group = { name = "Go To" } },
  { "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Goto definition", prefix = "" },
  { "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "Goto declaration" },
  { "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "Goto implementation" },
  { "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", desc = "Goto float diagnostics" },
  { "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", desc = "Goto type definition" },
  { "gr", "<cmd>lua vim.lsp.buf.references()<cr>", desc = "Goto references" },
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
