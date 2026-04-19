return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "williamboman/mason.nvim",
      version = "^1.0.0",
      config = true
    },
    {
      "williamboman/mason-lspconfig.nvim",
      version = "^1.0.0",
    },
    { "j-hui/fidget.nvim",       opts = {} },
    "folke/neodev.nvim",
    { "b0o/schemastore.nvim" },
    { "hrsh7th/cmp-nvim-lsp" },
  },
  config = function()
    require("mason").setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    local servers = require("listlessneko.plugins.lsp.servers")

    require("mason-lspconfig").setup({
      ensure_installed = vim.tbl_keys(servers),
    })

    require("neodev").setup()

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("gd", vim.lsp.buf.definition, "Goto Definition")
        map("gr", vim.lsp.buf.references, "Goto References")
        map("gi", vim.lsp.buf.implementation, "Goto Implementation")
        map("go", vim.lsp.buf.type_definition, "Type Definition")
        map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
        map("<leader>ws", require("telescope.builtin").lsp_workspace_symbols, "Workspace Symbols")
        map("<leader>Ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")

        map("<leader>rn", vim.lsp.buf.rename, "Rename all references")
        map("gl", vim.diagnostic.open_float, "Open Diagnostic Float")
        map("K", function()
          vim.lsp.buf.hover({ border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } })
        end, "Hover Documentation")
        map("gs", vim.lsp.buf.signature_help, "Signature Documentation")
        map("gD", vim.lsp.buf.declaration, "Goto Declaration")
        map("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")

        -- Thank you teej
        -- https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua#L502
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    local capabilities = vim.tbl_deep_extend("force",
      vim.lsp.protocol.make_client_capabilities(),
      require("cmp_nvim_lsp").default_capabilities()
    )

    vim.lsp.config('*', { capabilities = capabilities })

    for server_name, config in pairs(servers) do
      vim.lsp.config(server_name, config)
    end

    vim.lsp.enable(vim.tbl_keys(servers))

    -- Gleam LSP (not managed by mason)
    vim.lsp.config('gleam', {
      cmd = { "gleam", "lsp" },
      filetypes = { "gleam" },
      root_markers = { "gleam.toml", ".git" },
    })
    vim.lsp.enable('gleam')

    vim.diagnostic.config({
      title = false,
      underline = true,
      virtual_text = true,
      signs = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        source = "always",
        style = "minimal",
        border = "rounded",
        header = "",
        prefix = "",
      },
    })

    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
  end,
}
