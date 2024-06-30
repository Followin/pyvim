return {
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      print(vim.g.test);

      luasnip.config.setup {}
      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
          },
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        },
      }
    end,
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'folke/neodev.nvim',
      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },
      { 'simrat39/rust-tools.nvim' },
      "aznhe21/actions-preview.nvim",
    },
    config = function()
      local lspconfig = require('lspconfig')

      require('neodev').setup()

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      -- lua
      if vim.g.nixConfig.lsp.lua_ls.enabled then
        lspconfig.lua_ls.setup {
          capabilities = capabilities,
          cmd = { vim.g.nixConfig.lsp.lua_ls.serverPath },
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
              format = {
                enable = true,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  trailing_table_separator = "smart",
                },
              },
            },
          },
        }
      end

      -- rust
      local rt = require("rust-tools")

      rt.setup({
        server = {
          on_attach = function(_, bufnr)
            -- Hover actions
            vim.keymap.set("n", "<Leader>lb", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "<Leader>la", rt.code_action_group.code_action_group, { buffer = bufnr })
          end,
          capabilities = capabilities,
          settings = {
            ["rust-analyzer"] = {
              procMacro = {
                enable = true,
              },
              checkOnSave = {
                command = "clippy",
              },
            },
          },
        },
        tools = {
          hover_actions = {
            auto_focus = true,
          },
          runnables = {
            use_telescope = true,
          },
        },
      })

      -- typescript
      if vim.g.nixConfig.lsp.tsserver.enabled then
        lspconfig.tsserver.setup {
          cmd = { vim.g.nixConfig.lsp.tsserver.serverPath, '--stdio' },
          capabilities = capabilities,
        }
      end

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<leader>la', require("actions-preview").code_actions, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        end,
      })

      -- nix
      if vim.g.nixConfig.lsp.nixd.enabled then
        lspconfig.nixd.setup {
          capabilities = capabilities,
          cmd = { vim.g.nixConfig.lsp.nixd.serverPath },
        }
      end

      -- c#
      if vim.g.nixConfig.lsp.omnisharp.enabled then
        lspconfig.omnisharp.setup {
          capabilities = capabilities,
          cmd = { vim.g.nixConfig.lsp.omnisharp.serverPath },
          enable_import_completion = true,
        }
      end

      -- json
      if vim.g.nixConfig.lsp.jsonls.enabled then
        lspconfig.jsonls.setup {
          capabilities = capabilities,
          cmd = { vim.g.nixConfig.lsp.jsonls.serverPath, "--stdio" },
        }
      end

      -- protobuf
      if vim.g.nixConfig.lsp.bufls.enabled then
        lspconfig.bufls.setup {
          cmd = { vim.g.nixConfig.lsp.bufls.serverPath, "serve" },
          capabilities = capabilities,
        }
      end

      -- efm
      if vim.g.nixConfig.lsp.efm.enabled then
        lspconfig.efm.setup {
          cmd = { vim.g.nixConfig.lsp.efm.serverPath },
          capabilities = capabilities,
          init_options = { documentFormatting = true },
          filetypes = { 'typescript', 'json' },
          settings = {
            rootMarkers = { '.git/' },
            languages = {
              typescript = {
                {
                  formatCommand =
                      vim.g.nixConfig.lsp.efm.prettierdPath .. ' ${INPUT} ${--range-start=charStart} ${--range-end=charEnd} ${--tab-width=tabSize}',
                  formatStdin = true,
                  rootMarkers = {
                    '.prettierrc',
                    '.prettierrc.json',
                    '.prettierrc.toml',
                    '.prettierrc.json',
                    '.prettierrc.yml',
                    '.prettierrc.yaml',
                    '.prettierrc.json5',
                    '.prettierrc.js',
                    '.prettierrc.cjs',
                    '.prettierrc.config.js',
                    '.prettierrc.config.cjs',
                  },
                },
              },
              json = {
                {
                  formatCommand = vim.g.nixConfig.lsp.efm.fixJsonPath,
                },
              },
              jsonc = {
                {
                  formatCommand = vim.g.nixConfig.lsp.efm.fixJsonPath,
                },
              },
            },
          },
        }
      end

      -- diagnostics
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

      vim.diagnostic.config({
        update_in_insert = true,
      })

      require("funcs.autoformat")();
    end,
  },
}
