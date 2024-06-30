return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'norcalli/nvim-colorizer.lua',
      'nvim-treesitter/nvim-treesitter-context',
    },
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'c',
          'go',
          'lua',
          'rust',
          'typescript',
          'tsx',
          'nix',
          'json',
          'yaml',
          'toml',
          'html',
          'css',
          'javascript',
          'jsdoc',
        },
        auto_install = true,

        highlight = { enable = true },
        indent = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>A'] = '@parameter.inner',
            },
          },
        },
      }

      require('colorizer').setup()

      require('treesitter-context').setup()
    end,
  },
}
