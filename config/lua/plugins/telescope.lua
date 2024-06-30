return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    config = function()
      local telescope = require('telescope')

      telescope.setup {
        defaults = {
          vimgrep_arguments = {
            'rg',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
            '--glob', '!.git',
          },
        },
        pickers = {
          find_files = {
            find_command = { "fd", "-H", "--type", "f", "--follow", "--exclude", ".git", "--exclude", "node_modules" },
          },
        },
      }

      pcall(telescope.load_extension, 'fzf')

      local builtin = require('telescope.builtin')

      local function is_git_repo()
        vim.fn.system("git rev-parse --is-inside-work-tree")
        return vim.v.shell_error == 0
      end

      local function get_git_root()
        local dot_git_path = vim.fn.finddir(".git", ";")
        return vim.fn.fnamemodify(dot_git_path, ":h")
      end

      local search_opts = nil;

      local function get_search_opts()
        search_opts = is_git_repo() and {
          cwd = get_git_root(),
        } or {}

        get_search_opts = function() return search_opts end

        return search_opts
      end

      vim.keymap.set('n', '<C-p>', function() builtin.find_files(get_search_opts()) end, { desc = 'Find Files' })

      vim.keymap.set('n', '<leader>f/', function() builtin.current_buffer_fuzzy_find({ previewer = false }) end,
        { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>fg', function() builtin.live_grep(get_search_opts()) end, { desc = 'Live Grep' })
      vim.keymap.set('n', '<leader>fw', function() builtin.grep_string(get_search_opts()) end, { desc = 'Grep Word' })
      vim.keymap.set('n', '<leader>fb', function() builtin.buffers() end, { desc = 'show buffers' })
    end,
  },
}
