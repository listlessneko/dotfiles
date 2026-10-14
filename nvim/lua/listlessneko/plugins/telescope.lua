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

      -- Location pickers (grep, LSP, quickfix) use the <leader>ss layout with
      -- the path in place of the line text: "lnum:col │ path". The previewer
      -- already shows the text. Paths are cut from the start to fit the
      -- results window so the filename survives.
      local location_pos_width = 8
      local location_separator = " │ "
      local function location_path(path)
        path = vim.fn.fnamemodify(path, ":.")
        local status = require('telescope.state').get_status(vim.api.nvim_get_current_buf())
        local width = 30
        if status.picker and status.results_win and vim.api.nvim_win_is_valid(status.results_win) then
          -- Same budget telescope's own "truncate" uses, minus the position column
          width = vim.api.nvim_win_get_width(status.results_win) - #status.picker.selection_caret - 2
            - location_pos_width - #location_separator
        end
        return require('plenary.strings').truncate(path, width, "…", -1)
      end

      local location_displayer = require('telescope.pickers.entry_display').create({
        separator = location_separator,
        items = {
          { width = location_pos_width },
          { remaining = true },
        },
      })
      local function location_display(entry)
        local pos = entry.col and string.format("%d:%d", entry.lnum, entry.col) or tostring(entry.lnum)
        return location_displayer({
          { pos, "TelescopeResultsSpecialComment" },
          location_path(entry.filename),
        })
      end

      -- Wrap telescope's entry makers so every picker built on them gets the
      -- layout, with the per-call opts (cwd etc.) they'd normally receive
      local make_entry = require('telescope.make_entry')
      for _, name in ipairs({ "gen_from_vimgrep", "gen_from_quickfix" }) do
        local gen = make_entry[name]
        make_entry[name] = function(opts)
          local make = gen(opts)
          return function(...)
            local entry = make(...)
            -- File-only results (grep with files_with_matches) have no line
            if entry and entry.lnum then
              entry.display = location_display
              entry.__location = true
            end
            return entry
          end
        end
      end

      -- The location layout drops the line text, so show the characters the
      -- prompt matched in the preview instead of on the result row
      local preview_match_ns = vim.api.nvim_create_namespace('telescope_preview_match')

      -- Background only, so matched text keeps its syntax color. A foreground
      -- group like TelescopeMatching disappears on text already that color.
      -- A lighter grey than the TelescopePreviewLine (#404040) it sits on.
      local function set_preview_match_hl()
        vim.api.nvim_set_hl(0, 'TelescopePreviewFuzzyMatch', { bg = '#626262', default = true })
      end
      set_preview_match_hl()
      -- :colorscheme clears highlight groups, so define it again
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('telescope-preview-match', { clear = true }),
        callback = set_preview_match_hl,
      })
      local Picker = require('telescope.pickers')._Picker
      local last_picker

      local function highlight_preview_match(picker)
        local previewer = picker and picker.previewer
        local bufnr = previewer and previewer.state and previewer.state.bufnr
        if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end
        vim.api.nvim_buf_clear_namespace(bufnr, preview_match_ns, 0, -1)
        local entry = picker._selection_entry
        local prompt = picker:_get_prompt()
        if not (entry and entry.__location and entry.text and prompt ~= "" and picker.sorter.highlighter) then
          return
        end
        local line = vim.api.nvim_buf_get_lines(bufnr, entry.lnum - 1, entry.lnum, false)[1]
        -- Nil while the preview is still loading or showing another file
        local offset = line and line:find(entry.text, 1, true)
        if not offset then
          return
        end
        for _, hl in ipairs(picker.sorter:highlighter(prompt, entry.text) or {}) do
          local start = type(hl) == "table" and hl.start or hl
          local finish = type(hl) == "table" and (hl.finish or hl.start) or hl
          vim.api.nvim_buf_set_extmark(bufnr, preview_match_ns, entry.lnum - 1, offset + start - 2, {
            end_col = offset + finish - 1,
            hl_group = "TelescopePreviewFuzzyMatch",
            -- Above TelescopePreviewLine (4096), whose background would win
            priority = 4097,
          })
        end
      end

      local refresh_previewer = Picker.refresh_previewer
      function Picker:refresh_previewer()
        last_picker = self
        refresh_previewer(self)
        if not self.__preview_match_hooked then
          self.__preview_match_hooked = true
          -- Prompt edits that keep the same selection don't refresh the preview
          self:register_completion_callback(function()
            highlight_preview_match(self)
          end)
        end
        -- Files already open in a buffer are previewed on the next tick
        vim.schedule(function()
          highlight_preview_match(self)
        end)
      end

      -- Files read from disk are previewed once the read finishes
      local function location_buffer_previewer_maker(filepath, bufnr, opts)
        local callback = opts.callback
        opts.callback = function(...)
          if callback then
            callback(...)
          end
          highlight_preview_match(last_picker)
        end
        return require('telescope.previewers').buffer_previewer_maker(filepath, bufnr, opts)
      end

      -- The previewer turns 'wrap' off on every preview; turn it back on. This
      -- fires inside the preview buffer, so vim.wo is the preview window.
      vim.api.nvim_create_autocmd('User', {
        pattern = 'TelescopePreviewerLoaded',
        group = vim.api.nvim_create_augroup('telescope-preview-wrap', { clear = true }),
        callback = function()
          vim.wo.wrap = true
        end,
      })

      -- Matches on location rows fall in the text the row no longer shows
      local highlight_one_row = Picker.highlight_one_row
      function Picker:highlight_one_row(results_bufnr, prompt, display, row)
        local entry = self.manager:get_entry(self:get_index(row))
        if entry and entry.__location then
          return self.highlighter:hi_multiselect(row, self:is_multi_selected(entry))
        end
        return highlight_one_row(self, results_bufnr, prompt, display, row)
      end

      -- Break fuzzy-score ties by position so equally good matches stay in
      -- file, line, column order. Entries without a position keep telescope's
      -- default of shorter ordinal first.
      local function position_tiebreak(current, existing)
        if current.lnum and existing.lnum and current.filename and existing.filename then
          if current.filename ~= existing.filename then
            return current.filename < existing.filename
          end
          if current.lnum ~= existing.lnum then
            return current.lnum < existing.lnum
          end
          return (current.col or 0) < (existing.col or 0)
        end
        return #current.ordinal < #existing.ordinal
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
          -- "truncate" cuts paths from the start to fit the results window
          path_display = {
            "filename_first",
            "truncate",
          },
          previewer = true,
          dynamic_preview_title = true,
          file_previewer = left_truncate_title(require('telescope.previewers').vim_buffer_cat.new),
          grep_previewer = left_truncate_title(require('telescope.previewers').vim_buffer_vimgrep.new),
          buffer_previewer_maker = location_buffer_previewer_maker,
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
          tiebreak = position_tiebreak,
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
            "--sort=path",  -- ascending file order (single-threaded)
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
