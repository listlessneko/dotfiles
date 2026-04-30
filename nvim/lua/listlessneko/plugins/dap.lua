return {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-neotest/nvim-nio" },
    },
    "theHamsta/nvim-dap-virtual-text",
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = { "mason-org/mason.nvim" },
    },
  },
  keys = {
    { "<leader>D",  group = "Debug" },
    { "<leader>Db", function() require("dap").toggle_breakpoint() end,                                            desc = "Toggle Breakpoint" },
    { "<leader>DB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end,                    desc = "Conditional Breakpoint" },
    { "<leader>Dc", function() require("dap").continue() end,                                                     desc = "Continue / Start" },
    { "<leader>Dn", function() require("dap").step_over() end,                                                    desc = "Step Over" },
    { "<leader>Di", function() require("dap").step_into() end,                                                    desc = "Step Into" },
    { "<leader>Do", function() require("dap").step_out() end,                                                     desc = "Step Out" },
    { "<leader>Dr", function() require("dap").run_last() end,                                                     desc = "Run Last" },
    { "<leader>Dq", function() require("dap").terminate() end,                                                    desc = "Terminate" },
    { "<leader>Du", function() require("dapui").toggle() end,                                                     desc = "Toggle UI" },
    { "<leader>De", function() require("dapui").eval() end,                                                       desc = "Eval Expression",     mode = { "n", "v" } },
    { "<F5>",       function() require("dap").continue() end,                                                     desc = "Debug: Continue" },
    { "<F10>",      function() require("dap").step_over() end,                                                    desc = "Debug: Step Over" },
    { "<F11>",      function() require("dap").step_into() end,                                                    desc = "Debug: Step Into" },
    { "<F12>",      function() require("dap").step_out() end,                                                     desc = "Debug: Step Out" },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("mason-nvim-dap").setup({
      ensure_installed = { "codelldb" },
      automatic_installation = true,
      handlers = {},
    })

    dapui.setup()
    require("nvim-dap-virtual-text").setup({})

    vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "DiagnosticError",  numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn",   numhl = "" })
    vim.fn.sign_define("DapLogPoint",            { text = "◆", texthl = "DiagnosticInfo",   numhl = "" })
    vim.fn.sign_define("DapStopped",             { text = "▶", texthl = "DiagnosticOk",     numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected",  { text = "○", texthl = "DiagnosticError",  numhl = "" })

    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

    local mason_registry = require("mason-registry")
    local codelldb_root = mason_registry.is_installed("codelldb")
        and mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
      or ""

    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = codelldb_root .. "adapter/codelldb",
        args = { "--port", "${port}" },
      },
    }

    local last_executable
    local c_config = {
      {
        name = "Launch",
        type = "codelldb",
        request = "launch",
        program = function()
          last_executable = vim.fn.input({
            prompt = "Path to executable: ",
            default = last_executable or (vim.fn.getcwd() .. "/"),
            completion = "file",
          })
          return last_executable
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = function()
          local raw = vim.fn.input("Args (space-separated): ")
          if raw == "" then return {} end
          return vim.split(raw, " ", { trimempty = true })
        end,
      },
      {
        name = "Attach to process",
        type = "codelldb",
        request = "attach",
        pid = require("dap.utils").pick_process,
      },
    }

    dap.configurations.c = c_config
    dap.configurations.cpp = c_config
    dap.configurations.rust = c_config
  end,
}
