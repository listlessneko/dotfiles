local vertical_term_buf = nil

local function toggle_vertical_term()
  if vertical_term_buf and vim.api.nvim_buf_is_valid(vertical_term_buf) then
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == vertical_term_buf then
        vim.api.nvim_win_close(win, false)
        return
      end
    end
    vim.cmd("vsplit")
    vim.api.nvim_win_set_buf(0, vertical_term_buf)
    vim.cmd("startinsert")
  else
    vim.cmd("vsplit")
    vim.cmd("terminal")
    vertical_term_buf = vim.api.nvim_get_current_buf()
  end
end

return {
  mode = { "n", "v" },

  -- Top-level
  { "<leader>",
    group = { name = "Leader" },
    { "<leader>;", ":Alpha<CR>",                                                desc = "Dashboard" },
    { "<leader>w", ":w!<CR>",                                                   desc = "Save",                          mode = "n" },
    { "<leader>W", "<cmd>noautocmd w<cr>",                                      desc = "Save without formatting" },
    { "<leader>q", ":confirm q<CR>",                                            desc = "Quit" },
    { "<leader>f", require("listlessneko.config.utils").telescope_git_or_file,  desc = "Find Files (Root)" },
    { "<leader>o", require("telescope.builtin").buffers,                        desc = "Open Buffer" },
    { "<leader>a", "ggVG",                                                      desc = "Highlight entire file",         mode = "n" },
    { "<leader>v", desc = "Go to definition in a split" },
    { "<leader>br", "<cmd>Git status<CR>",                                      desc = "Git Status" },
    -- clipboard / void
    { "<leader>p", '"_dP',                                                      desc = "Void paste over selection",     mode = "x" },
    { "<leader>y", '"+y',                                                       desc = "Yank to system clipboard" },
    { "<leader>Y", '"+Y',                                                       desc = "Yank line to system clipboard", mode = "n" },
    { "<leader>d", '"_d',                                                       desc = "Delete to void" },
    -- increment / decrement
    { "<leader><C-a>", "<C-a>",                                                 desc = "Increment number",              mode = "n" },
    { "<leader><C-x>", "<C-x>",                                                 desc = "Decrement number",              mode = "n" },
  },

  -- (r)eplace
  { "<leader>r",
    group = { name = "Replace" },
    { "<leader>re", ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>',  desc = "Replace current word",                    mode = "n" },
    { "<leader>rc", ':%s/<C-r><C-w>/<C-r><C-w>/gc<Left><Left><Left>',        desc = "Replace current word (confirm)",           mode = "n" },
    { "<leader>rs", 'y:%s/\\V<C-r>"//gc<Left><Left><Left>',                   desc = "Replace selection in file (confirm)",      mode = "v" },
    { "<leader>rr", ":s///gc<Left><Left><Left><Left>",                        desc = "Replace within selection (confirm)",       mode = "v" },
  },

  -- (s)earch
  { "<leader>s",
    group = { name = "Search" },
    { "<leader>ss", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search current buffer" },
    { "<leader>sf", "<cmd>Telescope find_files<cr>",               desc = "Find File (CWD)" },
    { "<leader>sh", "<cmd>Telescope help_tags<cr>",                desc = "Find Help" },
    { "<leader>sH", "<cmd>Telescope highlights<cr>",                desc = "Find highlight groups" },
    { "<leader>sM", "<cmd>Telescope man_pages<cr>",                 desc = "Man Pages" },
    { "<leader>so", "<cmd>Telescope oldfiles<cr>",                  desc = "Open Recent File" },
    { "<leader>sR", "<cmd>Telescope registers<cr>",                 desc = "Registers" },
    { "<leader>sg", "<cmd>Telescope live_grep<cr>",                 desc = "Live Grep" },
    { "<leader>sw", "<cmd>Telescope grep_string<cr>",               desc = "Grep String" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>",                   desc = "Keymaps" },
    { "<leader>sC", "<cmd>Telescope commands<cr>",                  desc = "Commands" },
    { "<leader>sl", "<cmd>Telescope resume<cr>",                    desc = "Resume last search" },
    { "<leader>sc", "<cmd>Telescope git_commits<cr>",               desc = "Git commits" },
    { "<leader>sB", "<cmd>Telescope git_branches<cr>",              desc = "Git branches" },
    { "<leader>sm", "<cmd>Telescope git_status<cr>",                desc = "Git status" },
    { "<leader>sS", "<cmd>Telescope git_stash<cr>",                 desc = "Git stash" },
    { "<leader>sb", "<cmd>Telescope buffers<cr>",                   desc = "Buffers" },
    { "<leader>sN",
      function()
        require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("listlessneko.config") })
      end,
      desc = "Search Neovim Config",
    },
  },

  -- (g)it
  { "<leader>g",
    group = { name = "Git" },
    { "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", desc = "Prev Hunk" },
    { "<leader>gb", "<cmd>lua require 'gitsigns'.blame_line()<cr>",                            desc = "Blame" },
    { "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>",                         desc = "Preview Hunk" },
    { "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>",                           desc = "Reset Hunk" },
    { "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>",                         desc = "Reset Buffer" },
    { "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", desc = "Next Hunk" },
    { "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>",                           desc = "Stage Hunk" },
    { "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",                      desc = "Undo Stage Hunk" },
    { "<leader>go", require("telescope.builtin").git_status,                                   desc = "Open changed file" },
    { "<leader>gc", require("telescope.builtin").git_commits,                                  desc = "Checkout commit" },
    { "<leader>gC", require("telescope.builtin").git_bcommits,                                 desc = "Checkout commit (current file)" },
    { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>",                                         desc = "Git Diff" },
    { "<leader>gD", "<cmd>DiffviewOpen<cr>",                                                   desc = "Diffview (working tree)" },
    { "<leader>gL", "<cmd>DiffviewOpen HEAD~1<cr>",                                            desc = "Diffview last commit" },
    { "<leader>gP",
      function()
        vim.ui.input({ prompt = "Diffview range: " }, function(input)
          if input and input ~= "" then vim.cmd("DiffviewOpen " .. input) end
        end)
      end,
      desc = "Diffview range (prompt)",
    },
    { "<leader>gQ", "<cmd>DiffviewClose<cr>",                                                  desc = "Diffview close" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>",                                          desc = "Diffview file history" },
    { "<leader>gv", "<cmd>lua require('gitsigns').toggle_deleted()<cr>",                       desc = "Toggle deleted lines" },
    { "<leader>gU", ":UndotreeToggle<CR>",                                                     desc = "Toggle UndoTree" },
  },

  -- (l)sp
  { "<leader>l",
    group = { name = "LSP" },
    { "<leader>la", vim.lsp.buf.code_action,                              desc = "Code Action" },
    { "<leader>ls", vim.lsp.buf.signature_help,                           desc = "Signature Information" },
    { "<leader>lf", vim.lsp.buf.format,                                   desc = "Format" },
    { "<leader>li", require("telescope.builtin").lsp_implementations,     desc = "Implementation" },
    { "<leader>lw", require("telescope.builtin").diagnostics,             desc = "Diagnostics" },
    { "<leader>lc", require("listlessneko.config.utils").copyFilePathAndLineNumber, desc = "Copy File Path and Line Number" },
    { "<leader>ds", require("telescope.builtin").lsp_document_symbols,    desc = "Document Symbols" },
    { "<leader>ws", require("telescope.builtin").lsp_workspace_symbols,   desc = "Workspace Symbols" },
    { "<leader>Ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, desc = "Dynamic Workspace Symbols" },
    { "<leader>rn", vim.lsp.buf.rename,                                   desc = "Rename all references" },
    -- (w)orkspace folders
    { "<leader>wa", vim.lsp.buf.add_workspace_folder,    desc = "Add Workspace Folder" },
    { "<leader>wr", vim.lsp.buf.remove_workspace_folder, desc = "Remove Workspace Folder" },
    { "<leader>wl",
      function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
      desc = "List Workspace Folders",
    },
  },

  -- window splits
  { "<leader>|", "<C-w>v",         desc = "Split vertically",   mode = "n" },
  { "<leader>-", "<C-w>s",         desc = "Split horizontally", mode = "n" },
  { "<leader>=", "<C-w>=",         desc = "Equal split sizes",  mode = "n" },
  { "<leader>x", "<cmd>close<CR>", desc = "Close split",        mode = "n" },

  -- (t)erminal
  { "<leader>t",
    group = { name = "Terminal" },
    { "<leader>tf", "<cmd>1ToggleTerm direction=float<CR>",                                                             desc = "Float terminal",            mode = "n" },
    { "<leader>t-", "<cmd>2ToggleTerm direction=horizontal<CR>",                                                     desc = "Horizontal split terminal", mode = "n" },
    { "<leader>t|", toggle_vertical_term,                                                                               desc = "Vertical split terminal",   mode = "n" },
    { "<leader>tl", function() require("telescope.builtin").buffers({ show_all_buffers = true }) end,                desc = "List all buffers/terminals", mode = "n" },
    { "<leader>t",  ":w !python3<CR>",                           desc = "Run selected Python code",  mode = "v" },
  },

  -- (T)ab
  { "<leader>T",
    group = { name = "Tab" },
    { "<leader>To", "<cmd>tabnew<CR>",   desc = "Open new tab",           mode = "n" },
    { "<leader>Tw", "<cmd>tabclose<CR>", desc = "Close tab",              mode = "n" },
    { "<leader>Tn", "<cmd>tabn<CR>",     desc = "Next tab",               mode = "n" },
    { "<leader>Tp", "<cmd>tabp<CR>",     desc = "Prev tab",               mode = "n" },
    { "<leader>Tf", "<cmd>tabnew %<CR>", desc = "Open buffer in new tab", mode = "n" },
  },

  -- (Q)uery — BigQuery via visidata
  { "<leader>Q",
    group = { name = "Query" },
    { "<leader>Qr", ":BqvdRun<CR>", desc = "Run query in visidata", mode = { "n", "v" } },
  },
}
