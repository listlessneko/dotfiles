-- Fuzzy Finder (files, lsp, etc)
-- Contains comments from kickstarter and configuration from adib hanna

 return {
   {
    'nvim-telescope/telescope.nvim',
    event = 'vimenter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- if encountering errors, see telescope-fzf-native readme for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- this is only run then, not every time neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      -- local trouble = require('trouble.sources.telescope')
      local icons = require('listlessneko.config.icons')

      -- Plenary cuts over-long border titles from the end, hiding the filename.
      -- Wrap a previewer so its dynamic title is cut from the start instead.
      local function left_truncate_title(new_previewer)
        return function(...)
          local previewer = new_previewer(...)
          local dyn_title = previewer._dyn_title_fn
          if not dyn_title then
            return previewer
          end
          previewer._dyn_title_fn = function(self, entry)
            local title = dyn_title(self, entry)
            local winid = self.state and self.state.winid
            if type(title) ~= "string" or not winid or not vim.api.nvim_win_is_valid(winid) then
              return title
            end
            -- Matches plenary's limit: window width minus the padding spaces
            local max_width = vim.api.nvim_win_get_width(winid) - 2
            if max_width < 1 then
              return title
            end
            return require('plenary.strings').truncate(title, max_width, "…", -1)
          end
          return previewer
        end
      end

      -- Absolute path of the selected entry, or nil (with a warning) if it isn't a file
      local function selected_full_path()
        local entry = require('telescope.actions.state').get_selected_entry()
        -- Validate here: from_entry's own check errors on entries whose value is a table
        local path = entry and require('telescope.from_entry').path(entry, false, false)
        path = type(path) == "string" and vim.fn.expand(path) or nil
        if not path or (vim.fn.filereadable(path) == 0 and vim.fn.isdirectory(path) == 0) then
          vim.notify("Selected entry is not a file", vim.log.levels.WARN)
          return nil
        end
        return vim.fn.fnamemodify(path, ":p")
      end

      -- Echo the full path, which titles and results may cut off
      local function echo_full_path()
        local path = selected_full_path()
        if path then
          vim.api.nvim_echo({ { path } }, false, {})
        end
      end

      -- Copy the full path to the system clipboard
      local function yank_full_path()
        local path = selected_full_path()
        if path then
          vim.fn.setreg("+", path)
          vim.api.nvim_echo({ { "Copied path to clipboard" } }, false, {})
        end
      end

      telescope.setup({
        defaults = {
          border = true,  -- Enable border
          -- borderchars = { "█", " ", "▀", "█", "█", " ", " ", "▀" },
          -- borderchars = { "█", "█", "▄", "█", "█", "█", "▀", "█" },
          -- borderchars = { "═", "║", "═", "║", "╔", "╗", "╝", "╚" },
          -- borderchars = { "━", "┃", "━", "┃", "┏", "┓", "┛", "┗" },
          -- borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" }
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },  -- Custom border characters
          winblend = 10,
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<M-p>"] = echo_full_path,
              ["<M-y>"] = yank_full_path,
            },
            n = {
              ["p"] = echo_full_path,
              ["y"] = yank_full_path,
            },
          },
          -- path_display = formattedname,
          path_display = {
            "filename_first",
          },
          previewer = true,
          dynamic_preview_title = true,
          file_previewer = left_truncate_title(require('telescope.previewers').vim_buffer_cat.new),
          grep_previewer = left_truncate_title(require('telescope.previewers').vim_buffer_vimgrep.new),
          prompt_prefix = " " .. icons.ui.Telescope .. " ",
          selection_caret = icons.ui.BoldArrowRight .. " ",
          -- file_ignore_patterns = {
          --   "node_modules",
          --   "package-lock.json",
          --   ".env",
          --   "config"
          -- },
          initial_mode = "insert",
          select_strategy = "reset",
          sorting_strategy = "ascending",
          color_devicons = true,
          set_env = { ["colorterm"] = "truecolor" }, -- default = nil,
          layout_config = {
            prompt_position = "top",
            preview_cutoff = 120,
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob=!.git/",
            -- "--no-ignore",
          },
        },
        pickers = {
          find_files = {
            previewer = true,
            -- path_display = formattedname,
            hidden = true,
            -- no_ignore = true,
            -- no_ignore_parent = true,
            file_ignore_patterns = {
              "nvim/.git/",
              "%.env$",             -- Ignore .env files
              "^.git/",             -- Ignore .git directory
              "node_modules/",      -- Ignore node_modules
              -- "config/",            -- Ignore config directory
              "%.gitignore$"        -- Ignore .gitignore itself
            },
            respect_gitignore = true,
            layout_config = {
              height = 0.4,
              prompt_position = "top",
              preview_cutoff = 120,
            },
          },
          git_files = {
            previewer = true,
            -- path_display = formattedname,
            layout_config = {
              height = 0.4,
              prompt_position = "top",
              preview_cutoff = 120,
            },
          },
          buffers = {
            mappings = {
              i = {
                ["<c-d>"] = actions.delete_buffer,
              },
              n = {
                ["<c-d>"] = actions.delete_buffer,
              },
            },
            previewer = true,
            initial_mode = "normal",
            -- theme = "dropdown",
            layout_config = {
              height = 0.4,
              width = 0.6,
              prompt_position = "top",
              preview_cutoff = 120,
            },
          },
          current_buffer_fuzzy_find = {
            previewer = true,
            layout_config = {
              prompt_position = "top",
              preview_cutoff = 120,
            },
          },
          live_grep = {
            only_sort_text = true,
            previewer = true,
          },
          grep_string = {
            only_sort_text = true,
            previewer = true,
          },
          lsp_references = {
            show_line = true,
            previewer = true,
          },
          treesitter = {
            show_line = true,
            previewer = true,
          },
          colorscheme = {
            enable_preview = true,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              previewer = true,
              initial_mode = "normal",
              sorting_strategy = "ascending",
              layout_strategy = "horizontal",
              layout_config = {
                horizontal = {
                  width = 0.5,
                  height = 0.4,
                  preview_width = 0.6,
                },
              },
            }),
          },
          package_info = {
            -- optional theme (the extension doesn't set a default theme)
            -- theme = "ivy",
          },
          -- frecency = {
          --   default_workspace = "cwd",
          --   show_scores = true,
          --   show_unindexed = true,
          --   disable_devicons = false,
          --   ignore_patterns = {
          --     "*.git/*",
          --     "*/tmp/*",
          --     "*/lua-language-server/*",
          --   },
          -- },
        },
      })
      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
      end,
  },
}
